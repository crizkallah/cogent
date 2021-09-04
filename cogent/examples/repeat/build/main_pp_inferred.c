/*
This file is generated by Cogent

*/

typedef unsigned char u8;
typedef unsigned short u16;
typedef unsigned int u32;
typedef unsigned long long u64;
typedef struct unit_t {
            int dummy;
        } unit_t;
typedef struct bool_t {
            u8 boolean;
        } bool_t;
const int ENDIANNESS_TEST = 1;
static inline u16 swap_u16(u16 v)
{
    return v << 8 | v >> 8;
}
static inline u32 swap_u32(u32 v)
{
    v = (v << 8 & 0xFF00FF00) | (v >> 8 & 0xFF00FF);
    return v << 16 | v >> 16;
}
static inline u64 swap_u64(u64 v)
{
    v = (v << 8 & 0xFF00FF00FF00FF00) | (v >> 8 & 0x00FF00FF00FF00FF);
    v = (v << 16 & 0xFFFF0000FFFF0000) | (v >> 16 & 0x0000FFFF0000FFFF);
    return v << 32 | v >> 32;
}
static inline u8 be_u8_swap(u8 v)
{
    return v;
}
static inline u16 be_u16_swap(u16 v)
{
    return *(char *) &ENDIANNESS_TEST == 0 ? v : swap_u16(v);
}
static inline u32 be_u32_swap(u32 v)
{
    return *(char *) &ENDIANNESS_TEST == 0 ? v : swap_u32(v);
}
static inline u64 be_u64_swap(u64 v)
{
    return *(char *) &ENDIANNESS_TEST == 0 ? v : swap_u64(v);
}
static inline u8 le_u8_swap(u8 v)
{
    return v;
}
static inline u16 le_u16_swap(u16 v)
{
    return *(char *) &ENDIANNESS_TEST == 0 ? swap_u16(v) : v;
}
static inline u32 le_u32_swap(u32 v)
{
    return *(char *) &ENDIANNESS_TEST == 0 ? swap_u32(v) : v;
}
static inline u64 le_u64_swap(u64 v)
{
    return *(char *) &ENDIANNESS_TEST == 0 ? swap_u64(v) : v;
}
enum {
    LET_TRUE = 1,
};
enum {
    LETBANG_TRUE = 1,
};
enum untyped_func_enum {
    FUN_ENUM_binarySearch,
    FUN_ENUM_expstep,
    FUN_ENUM_expstop,
    FUN_ENUM_log2step,
    FUN_ENUM_log2stop,
    FUN_ENUM_myexp,
    FUN_ENUM_mylog2,
    FUN_ENUM_repeat_0,
    FUN_ENUM_repeat_1,
    FUN_ENUM_repeat_2,
    FUN_ENUM_searchNext,
    FUN_ENUM_searchStop,
    FUN_ENUM_wordarray_get_0,
    FUN_ENUM_wordarray_length_0,
};
typedef enum untyped_func_enum untyped_func_enum;
typedef untyped_func_enum t17;
typedef untyped_func_enum t18;
typedef untyped_func_enum t19;
typedef untyped_func_enum t14;
typedef untyped_func_enum t15;
typedef untyped_func_enum t20;
typedef untyped_func_enum t4;
typedef untyped_func_enum t5;
typedef untyped_func_enum t21;
typedef untyped_func_enum t22;
typedef untyped_func_enum t23;
typedef untyped_func_enum t10;
typedef untyped_func_enum t11;
typedef untyped_func_enum t24;
typedef struct t1 t1;
typedef struct t2 t2;
typedef struct t3 t3;
typedef struct t6 t6;
typedef struct t7 t7;
typedef struct t8 t8;
typedef struct t9 t9;
typedef struct t12 t12;
typedef struct t13 t13;
typedef struct t16 t16;
struct WordArray_u32 {
    int len;
    u32 *values;
};
typedef struct WordArray_u32 WordArray_u32;
struct t1 {
    WordArray_u32 *arr;
    u32 idx;
    u32 val;
};
struct t2 {
    u64 p1;
    u64 p2;
};
struct t3 {
    t2 acc;
    u64 obsv;
};
struct t6 {
    u64 n;
    t4 stop;
    t5 step;
    t2 acc;
    u64 obsv;
};
struct t7 {
    u32 p1;
    u32 p2;
};
struct t8 {
    WordArray_u32 *p1;
    u32 p2;
};
struct t9 {
    t7 acc;
    t8 obsv;
};
struct t12 {
    u64 n;
    t10 stop;
    t11 step;
    t7 acc;
    t8 obsv;
};
struct t13 {
    u32 acc;
    u32 obsv;
};
struct t16 {
    u64 n;
    t14 stop;
    t15 step;
    u32 acc;
    u32 obsv;
};
static inline u32 wordarray_get_0(t1);
static inline u32 wordarray_length_0(WordArray_u32 *);
static inline t2 repeat_0(t6);
static inline t7 repeat_2(t12);
static inline u32 repeat_1(t16);
static inline bool_t expstop(t13);
static inline bool_t log2stop(t3);
static inline bool_t searchStop(t9);
static inline u32 expstep(t13);
static inline t2 log2step(t3);
static inline t7 searchNext(t9);
static inline u32 binarySearch(t8);
static inline u32 myexp(t7);
static inline u64 mylog2(u64);
static inline u32 dispatch_t17(untyped_func_enum a2, WordArray_u32 *a3)
{
    return wordarray_length_0(a3);
}
static inline u32 dispatch_t18(untyped_func_enum a2, t1 a3)
{
    return wordarray_get_0(a3);
}
static inline t7 dispatch_t19(untyped_func_enum a2, t12 a3)
{
    return repeat_2(a3);
}
static inline bool_t dispatch_t14(untyped_func_enum a2, t13 a3)
{
    return expstop(a3);
}
static inline u32 dispatch_t15(untyped_func_enum a2, t13 a3)
{
    return expstep(a3);
}
static inline u32 dispatch_t20(untyped_func_enum a2, t16 a3)
{
    return repeat_1(a3);
}
static inline bool_t dispatch_t4(untyped_func_enum a2, t3 a3)
{
    return log2stop(a3);
}
static inline t2 dispatch_t5(untyped_func_enum a2, t3 a3)
{
    return log2step(a3);
}
static inline t2 dispatch_t21(untyped_func_enum a2, t6 a3)
{
    return repeat_0(a3);
}
static inline u32 dispatch_t22(untyped_func_enum a2, t7 a3)
{
    return myexp(a3);
}
static inline u32 dispatch_t23(untyped_func_enum a2, t8 a3)
{
    return binarySearch(a3);
}
static inline bool_t dispatch_t10(untyped_func_enum a2, t9 a3)
{
    return searchStop(a3);
}
static inline t7 dispatch_t11(untyped_func_enum a2, t9 a3)
{
    return searchNext(a3);
}
static inline u64 dispatch_t24(untyped_func_enum a2, u64 a3)
{
    return mylog2(a3);
}
typedef t8 binarySearch_arg;
typedef u32 binarySearch_ret;
typedef t13 expstep_arg;
typedef u32 expstep_ret;
typedef t13 expstop_arg;
typedef bool_t expstop_ret;
typedef t3 log2step_arg;
typedef t2 log2step_ret;
typedef t3 log2stop_arg;
typedef bool_t log2stop_ret;
typedef t7 myexp_arg;
typedef u32 myexp_ret;
typedef u64 mylog2_arg;
typedef u64 mylog2_ret;
typedef t6 repeat_0_arg;
typedef t2 repeat_0_ret;
typedef t16 repeat_1_arg;
typedef u32 repeat_1_ret;
typedef t12 repeat_2_arg;
typedef t7 repeat_2_ret;
typedef t9 searchNext_arg;
typedef t7 searchNext_ret;
typedef t9 searchStop_arg;
typedef bool_t searchStop_ret;
typedef t1 wordarray_get_0_arg;
typedef u32 wordarray_get_0_ret;
typedef WordArray_u32 *wordarray_length_0_arg;
typedef u32 wordarray_length_0_ret;
static inline bool_t expstop(t13 a1)
{
    t13 r2 = a1;
    bool_t r3 = (bool_t) {.boolean = 0U};
    
    return r3;
}
static inline bool_t log2stop(t3 a1)
{
    t2 r2 = a1.acc;
    u64 r3 = a1.obsv;
    u64 r4 = r2.p1;
    u64 r5 = r2.p2;
    bool_t r6 = (bool_t) {.boolean = r4 >= r3};
    
    return r6;
}
static inline bool_t searchStop(t9 a1)
{
    t7 r2 = a1.acc;
    t8 r3 = a1.obsv;
    u32 r4 = r2.p1;
    u32 r5 = r2.p2;
    WordArray_u32 *r6 = r3.p1;
    u32 r7 = r3.p2;
    u32 r8 = wordarray_length_0(r6);
    u32 r9 = 0U;
    t1 r10 = (t1) {.arr = r6, .idx = r4, .val = r9};
    u32 r11 = wordarray_get_0(r10);
    bool_t r12 = (bool_t) {.boolean = r4 >= r5};
    bool_t r13;
    
    if (r12.boolean)
        r13 = (bool_t) {.boolean = 1U};
    else {
        bool_t r14 = (bool_t) {.boolean = r4 < r8};
        bool_t r15 = (bool_t) {.boolean = r11 == r7};
        bool_t r16 = (bool_t) {.boolean = r14.boolean && r15.boolean};
        bool_t r17;
        
        if (r16.boolean)
            r17 = (bool_t) {.boolean = 1U};
        else
            r17 = (bool_t) {.boolean = 0U};
        r13 = r17;
    }
    
    bool_t r18 = r13;
    
    return r18;
}
static inline u32 expstep(t13 a1)
{
    u32 r2 = a1.acc;
    u32 r3 = a1.obsv;
    u32 r4 = r2 * r3;
    
    return r4;
}
static inline t2 log2step(t3 a1)
{
    t2 r2 = a1.acc;
    u64 r3 = a1.obsv;
    u64 r4 = r2.p1;
    u64 r5 = r2.p2;
    u64 r6 = 2U;
    u64 r7 = r4 * r6;
    u64 r8 = 1U;
    u64 r9 = r5 + r8;
    t2 r10 = (t2) {.p1 = r7, .p2 = r9};
    
    return r10;
}
static inline t7 searchNext(t9 a1)
{
    t7 r2 = a1.acc;
    t8 r3 = a1.obsv;
    u32 r4 = r2.p1;
    u32 r5 = r2.p2;
    WordArray_u32 *r6 = r3.p1;
    u32 r7 = r3.p2;
    u32 r8 = r5 - r4;
    u32 r9 = 2U;
    u32 r10 = r9 ? r8 / r9 : 0U;
    u32 r11 = r4 + r10;
    u32 r12 = 0U;
    t1 r13 = (t1) {.arr = r6, .idx = r11, .val = r12};
    u32 r14 = wordarray_get_0(r13);
    bool_t r15 = (bool_t) {.boolean = r14 < r7};
    t7 r16;
    
    if (r15.boolean) {
        u32 r17 = 1U;
        u32 r18 = r11 + r17;
        
        r16 = (t7) {.p1 = r18, .p2 = r5};
    } else {
        bool_t r19 = (bool_t) {.boolean = r14 > r7};
        t7 r20;
        
        if (r19.boolean)
            r20 = (t7) {.p1 = r4, .p2 = r11};
        else
            r20 = (t7) {.p1 = r11, .p2 = r5};
        r16 = r20;
    }
    
    t7 r21 = r16;
    
    return r21;
}
static inline u32 binarySearch(t8 a1)
{
    WordArray_u32 *r2 = a1.p1;
    u32 r3 = a1.p2;
    u32 r4 = wordarray_length_0(r2);
    u64 r5 = (u64) r4;
    t10 r6 = FUN_ENUM_searchStop;
    t11 r7 = FUN_ENUM_searchNext;
    u32 r8 = 0U;
    t7 r9 = (t7) {.p1 = r8, .p2 = r4};
    t8 r10 = (t8) {.p1 = r2, .p2 = r3};
    t12 r11 = (t12) {.n = r5, .stop = r6, .step = r7, .acc = r9, .obsv = r10};
    t7 r12 = repeat_2(r11);
    u32 r13 = r12.p1;
    u32 r14 = r12.p2;
    u32 r15 = r13;
    
    return r15;
}
static inline u32 myexp(t7 a1)
{
    u32 r2 = a1.p1;
    u32 r3 = a1.p2;
    u64 r4 = (u64) r3;
    t14 r5 = FUN_ENUM_expstop;
    t15 r6 = FUN_ENUM_expstep;
    u32 r7 = 1U;
    t16 r8 = (t16) {.n = r4, .stop = r5, .step = r6, .acc = r7, .obsv = r2};
    u32 r9 = repeat_1(r8);
    
    return r9;
}
static inline u64 mylog2(u64 a1)
{
    u64 r2 = a1;
    t4 r3 = FUN_ENUM_log2stop;
    t5 r4 = FUN_ENUM_log2step;
    u64 r5 = 1U;
    u64 r6 = 0U;
    t2 r7 = (t2) {.p1 = r5, .p2 = r6};
    t6 r8 = (t6) {.n = r2, .stop = r3, .step = r4, .acc = r7, .obsv = r2};
    t2 r9 = repeat_0(r8);
    u64 r10 = r9.p1;
    u64 r11 = r9.p2;
    u64 r12 = r11;
    
    return r12;
}
u32 repeat_1(t16 args)
{
    u64 i = 0;
    t13 a;
    
    a.acc = args.acc;
    a.obsv = args.obsv;
    for (i = 0; i < args.n; i++) {
        bool_t b = dispatch_t14(args.stop, a);
        
        if (b.boolean)
            break;
        a.acc = dispatch_t15(args.step, a);
    }
    return a.acc;
}
t7 repeat_2(t12 args)
{
    u64 i = 0;
    t9 a;
    
    a.acc = args.acc;
    a.obsv = args.obsv;
    for (i = 0; i < args.n; i++) {
        bool_t b = dispatch_t10(args.stop, a);
        
        if (b.boolean)
            break;
        a.acc = dispatch_t11(args.step, a);
    }
    return a.acc;
}
t2 repeat_0(t6 args)
{
    u64 i = 0;
    t3 a;
    
    a.acc = args.acc;
    a.obsv = args.obsv;
    for (i = 0; i < args.n; i++) {
        bool_t b = dispatch_t4(args.stop, a);
        
        if (b.boolean)
            break;
        a.acc = dispatch_t5(args.step, a);
    }
    return a.acc;
}
u32 wordarray_get_0(t1 args)
{
    if (args.idx >= args.arr->len)
        return args.val;
    return args.arr->values[args.idx];
}
u32 wordarray_length_0(WordArray_u32 *array)
{
    return array->len;
}


