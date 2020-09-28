--
-- Copyright 2020, Data61
-- Commonwealth Scientific and Industrial Research Organisation (CSIRO)
-- ABN 41 687 119 230.
--
-- This software may be distributed and modified according to the terms of
-- the GNU General Public License version 2. Note that NO WARRANTY is provided.
-- See "LICENSE_GPLv2.txt" for details.
--
-- @TAG(DATA61_GPL)
--
-- Prototype of the SPI driver for tk1 from https://github.com/seL4/util_libs

import Data.Word
import Data.Bits
import Data.Maybe
import Control.Monad.State

{- Models the set of register used to communicate with the hardware.
Note that in the actual C struct there should be some padding.
-}
data SpiRegs = SpiRegs 
    { command1 :: Word32
    , command2 :: Word32
    , timing1 :: Word32
    , timing2 :: Word32
    , xferStatus :: Word32
    , fifoStatus :: Word32
    , dmaCtl :: Word32
    , dmaBlk :: Word32
    , txFifo :: Word32
    , rxFifo :: Word32
    , spareCtl :: Word32
    } deriving (Show)

data SpiSlaveCfg = SpiSlaveCfg 
    { id :: Int
    , speedHz :: Word64
    , nssUdelay :: Word32
    , fbDelay :: Word32
    } deriving (Show)

data SpiCsState = SpiCsAssert | SpiCsRelax deriving (Enum)

type CsFn a = SpiSlaveCfg -> Int -> State a () 

{- In the C code, the spi_bus_t struct is on the heap and contains 
volatile fields, function pointers, void * pointers and pointers arrays.
For the pointers to arrays, we model these as lists.
For the void * pointer, we model this as some type variable, i.e. it
can be anything.

We make the whole SpiBus part of the global state.
-}
data SpiBus a = SpiBus 
    { regs :: SpiRegs  -- this is volatile in C
    , clockMode :: Word32
    , inProgress :: Bool
    , txbuf :: [Word8]
    , rxbuf :: Maybe [Word8]
    , txsize :: Int
    , rxsize :: Int
    , cs :: Maybe (CsFn (SpiBus a))
    , cb :: Int -> a -> State (SpiBus a) ()
    , token :: a
    , currSlave :: SpiSlaveCfg
    }


-- #defines
spiXferStsRdy :: Word32
spiXferStsRdy = setBit 0 39

spiCmd1Go :: Word32
spiCmd1Go = setBit 0 31

spiFifoStsRxFifoFlush :: Word32
spiFifoStsRxFifoFlush = setBit 0 15

spiFifoStsTxFifoFlush :: Word32
spiFifoStsTxFifoFlush = setBit 0 14

fifoSize :: Int
fifoSize = 64

{- Getters and setters for fields in SpiBus.
This mainly makes functions, which do the real work, more readable.
-}
getRegs :: State (SpiBus a) SpiRegs
getRegs = gets regs 

putRegs :: SpiRegs -> State (SpiBus a) ()
putRegs r = modify $ \s -> s { regs = r} 

getInProgress :: State (SpiBus a) Bool
getInProgress = gets inProgress 

putInProgress :: Bool -> State (SpiBus a) ()
putInProgress b = modify $ \s -> s { inProgress = b}

getTxbuf :: State (SpiBus a) [Word8]
getTxbuf = gets txbuf

putTxbuf :: [Word8] -> State (SpiBus a) ()
putTxbuf xs = modify $ \s -> s { txbuf = xs }

getRxbuf :: State (SpiBus a) (Maybe [Word8])
getRxbuf = gets rxbuf

putRxbuf :: Maybe [Word8] -> State (SpiBus a) ()
putRxbuf xs = modify $ \s -> s { rxbuf = xs }

getTxsize :: State (SpiBus a) Int
getTxsize = gets txsize

putTxsize :: Int -> State (SpiBus a) ()
putTxsize n = modify $ \s -> s { txsize = n }

getRxsize :: State (SpiBus a) Int
getRxsize = gets rxsize

putRxsize :: Int -> State (SpiBus a) ()
putRxsize n = modify $ \s -> s { rxsize = n }

getCs :: State (SpiBus a) (Maybe (CsFn (SpiBus a)))
getCs = gets cs

putCs :: Maybe (CsFn (SpiBus a)) -> State (SpiBus a) ()
putCs c = modify $ \s -> s { cs = c}

getCb :: State (SpiBus a) (Int -> a -> State (SpiBus a) ())
getCb = gets cb

putCb :: (Int -> a -> State (SpiBus a) ()) -> State (SpiBus a) ()
putCb c = modify $ \s -> s { cb = c }

getToken :: State (SpiBus a) a
getToken = gets token

putToken :: a -> State (SpiBus a) ()
putToken tok = modify $ \s -> s { token = tok }

getCurrSlave :: State (SpiBus a) SpiSlaveCfg
getCurrSlave = gets currSlave

putCurrSlave :: SpiSlaveCfg -> State (SpiBus a) ()
putCurrSlave slave = modify $ \s -> s { currSlave = slave }

{- Getters and setters for fields in SpiRegs.
We may want to change this to account for the fact that they are volatile.

Note that since the fields are "volatile", in the getters, the value may
actually change. Similarly for the setters.
-}
getCommand1 :: State (SpiBus a) Word32 
getCommand1 = do
    r <- getRegs
    return $ command1 r

putCommand1 :: Word32 -> State (SpiBus a) ()
putCommand1 x = do
    r <- getRegs
    s <- get
    put $ s { regs = (r { command1 = x})}
        
getCommand2 :: State (SpiBus a) Word32 
getCommand2 = do
    r <- getRegs
    return $ command2 r

putCommand2 :: Word32 -> State (SpiBus a) ()
putCommand2 x = do
    r <- getRegs
    s <- get
    put $ s { regs = (r { command2 = x})}

getTiming1 :: State (SpiBus a) Word32 
getTiming1 = do
    r <- getRegs
    return $ timing1 r 

putTiming1 :: Word32 -> State (SpiBus a) ()
putTiming1 x = do
    r <- getRegs
    s <- get
    put $ s { regs = (r { timing1 = x})}

getXferStatus :: State (SpiBus a) Word32 
getXferStatus = do
    r <- getRegs
    return $ xferStatus r 

putXferStatus :: Word32 -> State (SpiBus a) ()
putXferStatus x = do
    r <- getRegs
    s <- get
    put $ s { regs = (r { xferStatus = x})}

getFifoStatus :: State (SpiBus a) Word32 
getFifoStatus = do
    r <- getRegs
    return $ fifoStatus r 

putFifoStatus :: Word32 -> State (SpiBus a) ()
putFifoStatus x = do
    r <- getRegs
    s <- get
    put $ s { regs = (r { fifoStatus = x})}

getDmaCtl :: State (SpiBus a) Word32 
getDmaCtl = do
    r <- getRegs
    return $ dmaCtl r 

putDmaCtl :: Word32 -> State (SpiBus a) ()
putDmaCtl x = do
    r <- getRegs
    s <- get
    put $ s { regs = (r { dmaCtl = x})}

getDmaBlk :: State (SpiBus a) Word32 
getDmaBlk = do
    r <- getRegs
    return $ dmaBlk r

putDmaBlk :: Word32 -> State (SpiBus a) ()
putDmaBlk x = do
    r <- getRegs
    s <- get
    put $ s { regs = (r { dmaBlk = x})}

getTxFifo :: State (SpiBus a) Word32 
getTxFifo = do
    r <- getRegs
    return $ txFifo r

putTxFifo :: Word32 -> State (SpiBus a) ()
putTxFifo x = do
    r <- getRegs
    s <- get
    put $ s { regs = (r { txFifo = x})}

getRxFifo :: State (SpiBus a) Word32 
getRxFifo = do
    r <- getRegs
    return $ rxFifo r 

putRxFifo :: Word32 -> State (SpiBus a) ()
putRxFifo x = do
    r <- getRegs
    s <- get
    put $ s { regs = (r { rxFifo = x})}

-- Actual implementation logic

{- Read or flush the 'rxfifo' queue @n@ many times and 
update the 'rxbuf' field if it contains a valid list.
-}
readOrFlushRx :: Int -> State (SpiBus a) ()
readOrFlushRx n
    | n <= 0    = return ()
    | otherwise = do
        x <- getRxFifo
        readOrFlushRx $ n - 1
        let y = fromInteger $ toInteger $ x .&. 0xff
        xs <- getRxbuf
        maybe (return ()) (\ys -> putRxbuf (Just (y:ys))) xs

{- Either assert or release chip select if a chip select function is
provided i.e. flip the GPIO pin. So some hidden state is altered.
-}
chipSelect :: SpiCsState -> State (SpiBus a) ()
chipSelect s = do
    c <- getCs
    slave <- getCurrSlave
    maybe (return ()) (\f -> f slave (fromEnum s)) c

{- Reads or flushes the rxfifo queue, signal that the SPI operations
are complete, and runs the provided callback function.
-}
finishSpiTransfer :: State (SpiBus a) ()
finishSpiTransfer = do
    tx <- getTxsize
    rx <- getRxsize
    readOrFlushRx $ tx + rx
    x <- getXferStatus
    putXferStatus $ x .|. spiXferStsRdy
    putInProgress False
    chipSelect SpiCsRelax
    c <- getCb
    tok <- getToken
    c (tx + rx) tok

{- Either handles the SPI transfer or it cancels it depending on
whether the hardware device is ready.
-}
spiHandleIrq :: State (SpiBus a) ()
spiHandleIrq = do
    xferStat <- getXferStatus
    if (xferStat .&. spiXferStsRdy) /= 0
        then finishSpiTransfer
        else do
            cmd1 <- getCommand1
            putCommand1 $ (.&.) cmd1 $ complement spiCmd1Go
            fifoStat <- getFifoStatus
            putFifoStatus $ fifoStat .|. spiFifoStsRxFifoFlush .|. 
                spiFifoStsTxFifoFlush
            xferStat' <- getXferStatus
            putXferStatus $ xferStat .|. spiXferStsRdy
            putInProgress False
            chipSelect SpiCsRelax
            c <- getCb
            tok <- getToken
            c (-1) tok

{- Write the data in the tx buffer to the txfifo queue and then
write as many 0s to the queue as the length of the rx buffer minus
the length of the tx buffer.
-}
writeTx :: Int -> Int -> State (SpiBus a) ()
writeTx i n
    | i < n && i >= 0 = do
        tx <- getTxbuf
        if i < length tx
            then do putTxFifo $ fromInteger $ toInteger $ tx !! i
            else do putTxFifo 0
        writeTx (i+1) n
    | otherwise = return ()
      
{- Transfer the data in the tx buffer and signal the hardware to
handle it.
-}
startSpiTransfer :: State (SpiBus a) ()
startSpiTransfer = do
    chipSelect SpiCsAssert
    tx <- getTxsize
    rx <- getRxsize
    putDmaBlk $ fromIntegral $ tx + rx - 1
    writeTx 0 $ tx + rx - 1
    cmd1 <- getCommand1
    putCommand1 $ cmd1 .|. spiCmd1Go

{- Set up the transfer.

Not sure that we still want the @c@ argument to be possibly
'Nothing' as this check only occurs in C since pointers can be
NULL.
-}
spiXfer 
    :: [Word8] 
    -> Int 
    -> Maybe [Word8] 
    -> Int 
    -> Maybe (Int -> a -> State (SpiBus a) ()) 
    -> a 
    -> State (SpiBus a) Int
spiXfer txb tx rxb rx c tok = do
    p <- getInProgress
    if p
        then return (-1)
        else
            if tx + rx > fifoSize
                then return (-2)
                else
                    if isNothing c
                        then return (-3)
                        else do
                            putTxbuf txb
                            putTxsize tx
                            putRxbuf rxb
                            putRxsize rx
                            putInProgress True
                            putCb $ fromJust c
                            putToken tok
                            startSpiTransfer
                            return 0

{- Set the current slave to be talked to. 
Note that this is currently incomplete due to the C version also
being incomplete.
-}
spiPrepareTransfer :: SpiSlaveCfg -> State (SpiBus a) ()
spiPrepareTransfer slave = putCurrSlave slave