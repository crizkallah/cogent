(*
This file is generated by Cogent

*)

theory Generated_Shallow_Normal
imports "Generated_ShallowShared"
begin

definition
  id4 :: " U4 \<Rightarrow>  U4"
where
  "id4 ds\<^sub>0 \<equiv> HOL.Let ds\<^sub>0 (\<lambda>x. x)"

definition
  id2 :: " U2 \<Rightarrow>  U2"
where
  "id2 ds\<^sub>0 \<equiv> HOL.Let ds\<^sub>0 (\<lambda>x. x)"

definition
  foo :: " RL\<^sub>T \<Rightarrow>  RL\<^sub>T"
where
  "foo ds\<^sub>0 \<equiv> HOL.Let ds\<^sub>0 (\<lambda>r. Let\<^sub>d\<^sub>s (R.f1\<^sub>f r) (\<lambda>ds\<^sub>1. HOL.If ds\<^sub>1 (HOL.Let (HOL.Let (R.f3\<^sub>f r) (\<lambda>an\<^sub>4. HOL.Let (u4_to_u8 an\<^sub>4) (\<lambda>an\<^sub>3. HOL.Let (12 :: 8 word) (\<lambda>an\<^sub>6. HOL.Let ((AND) an\<^sub>3 an\<^sub>6) (\<lambda>an\<^sub>2. u8_to_u4 an\<^sub>2))))) (\<lambda>v. R.f3\<^sub>f_update (\<lambda>_. v) r)) (HOL.Let (HOL.Let (R.f2\<^sub>f r) (\<lambda>an\<^sub>1\<^sub>1. HOL.Let (u2_to_u8 an\<^sub>1\<^sub>1) (\<lambda>an\<^sub>1\<^sub>0. HOL.Let (1 :: 8 word) (\<lambda>an\<^sub>1\<^sub>3. HOL.Let ((+) an\<^sub>1\<^sub>0 an\<^sub>1\<^sub>3) (\<lambda>an\<^sub>9. u8_to_u2 an\<^sub>9))))) (\<lambda>v. R.f2\<^sub>f_update (\<lambda>_. v) r))))"

end