(*
This file is generated by Cogent

*)

theory Generated_Shallow_Desugar
imports "Generated_ShallowShared"
begin

definition
  wordarray_get_u32 :: "(32 word WordArray, 32 word) T0 \<Rightarrow> 32 word"
where
  "wordarray_get_u32 ds\<^sub>0 \<equiv> HOL.Let ds\<^sub>0 (\<lambda>x. (wordarray_get :: (32 word WordArray, 32 word) T0 \<Rightarrow> 32 word) x)"

definition
  wordarray_length_u32 :: "32 word WordArray \<Rightarrow> 32 word"
where
  "wordarray_length_u32 ds\<^sub>0 \<equiv> HOL.Let ds\<^sub>0 (\<lambda>x. (wordarray_length :: 32 word WordArray \<Rightarrow> 32 word) x)"

definition
  wordarray_put2_u32 :: "(32 word WordArray, 32 word, 32 word) WordArrayPutP \<Rightarrow> 32 word WordArray"
where
  "wordarray_put2_u32 ds\<^sub>0 \<equiv> HOL.Let ds\<^sub>0 (\<lambda>x. (wordarray_put2 :: (32 word WordArray, 32 word, 32 word) WordArrayPutP \<Rightarrow> 32 word WordArray) x)"

definition
  add :: "(32 word, 32 word, unit) ElemAO \<Rightarrow> 32 word"
where
  "add ds\<^sub>0 \<equiv> HOL.Let (take\<^sub>c\<^sub>o\<^sub>g\<^sub>e\<^sub>n\<^sub>t ds\<^sub>0 ElemAO.elem\<^sub>f) (\<lambda>(elem,ds\<^sub>2). HOL.Let (take\<^sub>c\<^sub>o\<^sub>g\<^sub>e\<^sub>n\<^sub>t ds\<^sub>2 ElemAO.acc\<^sub>f) (\<lambda>(acc,ds\<^sub>3). HOL.Let (take\<^sub>c\<^sub>o\<^sub>g\<^sub>e\<^sub>n\<^sub>t ds\<^sub>3 ElemAO.obsv\<^sub>f) (\<lambda>(obsv,ds\<^sub>1). (+) elem acc)))"

definition
  sum_arr :: "32 word WordArray \<Rightarrow> 32 word"
where
  "sum_arr ds\<^sub>0 \<equiv> HOL.Let ds\<^sub>0 (\<lambda>wa. HOL.Let ((wordarray_length :: 32 word WordArray \<Rightarrow> 32 word) wa) (\<lambda>e. HOL.Let (WordArrayMapNoBreakP.make wa (0 :: 32 word) e add (0 :: 32 word) ()) (\<lambda>arg. (wordarray_fold_no_break :: (32 word WordArray, 32 word, 32 word, (32 word, 32 word, unit) ElemAO \<Rightarrow> 32 word, 32 word, unit) WordArrayMapNoBreakP \<Rightarrow> 32 word) arg)))"

definition
  dec :: "(32 word, unit, unit) ElemAO \<Rightarrow> (32 word, unit) T0"
where
  "dec ds\<^sub>0 \<equiv> HOL.Let (take\<^sub>c\<^sub>o\<^sub>g\<^sub>e\<^sub>n\<^sub>t ds\<^sub>0 ElemAO.elem\<^sub>f) (\<lambda>(elem,ds\<^sub>2). HOL.Let (take\<^sub>c\<^sub>o\<^sub>g\<^sub>e\<^sub>n\<^sub>t ds\<^sub>2 ElemAO.acc\<^sub>f) (\<lambda>(acc,ds\<^sub>3). HOL.Let (take\<^sub>c\<^sub>o\<^sub>g\<^sub>e\<^sub>n\<^sub>t ds\<^sub>3 ElemAO.obsv\<^sub>f) (\<lambda>(obsv,ds\<^sub>1). T0.make ((-) elem (1 :: 32 word)) acc)))"

definition
  dec_arr :: "32 word WordArray \<Rightarrow> (32 word WordArray, unit) T0"
where
  "dec_arr ds\<^sub>0 \<equiv> HOL.Let ds\<^sub>0 (\<lambda>wa. HOL.Let ((wordarray_length :: 32 word WordArray \<Rightarrow> 32 word) wa) (\<lambda>end. HOL.Let (WordArrayMapNoBreakP.make wa (0 :: 32 word) end dec () ()) (\<lambda>arg. (wordarray_map_no_break :: (32 word WordArray, 32 word, 32 word, (32 word, unit, unit) ElemAO \<Rightarrow> (32 word, unit) T0, unit, unit) WordArrayMapNoBreakP \<Rightarrow> (32 word WordArray, unit) T0) arg)))"

definition
  inc :: "(32 word, unit, unit) ElemAO \<Rightarrow> (32 word, unit) T0"
where
  "inc ds\<^sub>0 \<equiv> HOL.Let (take\<^sub>c\<^sub>o\<^sub>g\<^sub>e\<^sub>n\<^sub>t ds\<^sub>0 ElemAO.elem\<^sub>f) (\<lambda>(elem,ds\<^sub>2). HOL.Let (take\<^sub>c\<^sub>o\<^sub>g\<^sub>e\<^sub>n\<^sub>t ds\<^sub>2 ElemAO.acc\<^sub>f) (\<lambda>(acc,ds\<^sub>3). HOL.Let (take\<^sub>c\<^sub>o\<^sub>g\<^sub>e\<^sub>n\<^sub>t ds\<^sub>3 ElemAO.obsv\<^sub>f) (\<lambda>(obsv,ds\<^sub>1). T0.make ((+) elem (1 :: 32 word)) acc)))"

definition
  inc_arr :: "32 word WordArray \<Rightarrow> (32 word WordArray, unit) T0"
where
  "inc_arr ds\<^sub>0 \<equiv> HOL.Let ds\<^sub>0 (\<lambda>wa. HOL.Let ((wordarray_length :: 32 word WordArray \<Rightarrow> 32 word) wa) (\<lambda>end. HOL.Let (WordArrayMapNoBreakP.make wa (0 :: 32 word) end inc () ()) (\<lambda>arg. (wordarray_map_no_break :: (32 word WordArray, 32 word, 32 word, (32 word, unit, unit) ElemAO \<Rightarrow> (32 word, unit) T0, unit, unit) WordArrayMapNoBreakP \<Rightarrow> (32 word WordArray, unit) T0) arg)))"

definition
  mul :: "(32 word, 32 word, unit) ElemAO \<Rightarrow> 32 word"
where
  "mul ds\<^sub>0 \<equiv> HOL.Let (take\<^sub>c\<^sub>o\<^sub>g\<^sub>e\<^sub>n\<^sub>t ds\<^sub>0 ElemAO.elem\<^sub>f) (\<lambda>(elem,ds\<^sub>2). HOL.Let (take\<^sub>c\<^sub>o\<^sub>g\<^sub>e\<^sub>n\<^sub>t ds\<^sub>2 ElemAO.acc\<^sub>f) (\<lambda>(acc,ds\<^sub>3). HOL.Let (take\<^sub>c\<^sub>o\<^sub>g\<^sub>e\<^sub>n\<^sub>t ds\<^sub>3 ElemAO.obsv\<^sub>f) (\<lambda>(obsv,ds\<^sub>1). (*) elem acc)))"

definition
  mul_arr :: "32 word WordArray \<Rightarrow> 32 word"
where
  "mul_arr ds\<^sub>0 \<equiv> HOL.Let ds\<^sub>0 (\<lambda>wa. HOL.Let ((wordarray_length :: 32 word WordArray \<Rightarrow> 32 word) wa) (\<lambda>e. HOL.Let (WordArrayMapNoBreakP.make wa (0 :: 32 word) e mul (0 :: 32 word) ()) (\<lambda>arg. (wordarray_fold_no_break :: (32 word WordArray, 32 word, 32 word, (32 word, 32 word, unit) ElemAO \<Rightarrow> 32 word, 32 word, unit) WordArrayMapNoBreakP \<Rightarrow> 32 word) arg)))"

end
