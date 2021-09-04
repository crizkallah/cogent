(*
This file is generated by Cogent

*)

theory Generated_ShallowTuplesProof
imports "Generated_Shallow_Desugar"
"Generated_Shallow_Desugar_Tuples"
"CogentShallow.ShallowTuples"
begin

ML \<open>
structure ShallowTuplesRules_Generated =
  Named_Thms (
    val name = Binding.name "ShallowTuplesRules_Generated"
    val description = ""
  )
\<close>
setup \<open> ShallowTuplesRules_Generated.setup \<close>


ML \<open>
structure ShallowTuplesThms_Generated =
  Named_Thms (
    val name = Binding.name "ShallowTuplesThms_Generated"
    val description = ""
  )
\<close>
setup \<open> ShallowTuplesThms_Generated.setup \<close>


overloading shallow_tuples_rel_StepParam \<equiv> shallow_tuples_rel begin
  definition "shallow_tuples_rel_StepParam (x :: ('x1, 'x2) Generated_ShallowShared.StepParam) (xt :: ('xt1, 'xt2) Generated_ShallowShared_Tuples.StepParam) \<equiv>
    shallow_tuples_rel (Generated_ShallowShared.StepParam.acc\<^sub>f x) (Generated_ShallowShared_Tuples.StepParam.acc\<^sub>f xt) \<and>
    shallow_tuples_rel (Generated_ShallowShared.StepParam.obsv\<^sub>f x) (Generated_ShallowShared_Tuples.StepParam.obsv\<^sub>f xt)"
end
lemma shallow_tuples_rule_make__StepParam [ShallowTuplesRules_Generated]:
  "\<lbrakk>
     shallow_tuples_rel x1 xt1;
     shallow_tuples_rel x2 xt2
  \<rbrakk> \<Longrightarrow> shallow_tuples_rel (Generated_ShallowShared.StepParam.make x1 x2) \<lparr>Generated_ShallowShared_Tuples.StepParam.acc\<^sub>f = xt1, obsv\<^sub>f = xt2\<rparr>"
  by (simp add: shallow_tuples_rel_StepParam_def Generated_ShallowShared.StepParam.defs Generated_ShallowShared_Tuples.StepParam.defs)
lemma shallow_tuples_rule__StepParam__acc\<^sub>f [ShallowTuplesThms_Generated]:
  "shallow_tuples_rel (x :: ('x1, 'x2) Generated_ShallowShared.StepParam) (xt :: ('xt1, 'xt2) Generated_ShallowShared_Tuples.StepParam) \<Longrightarrow>
   shallow_tuples_rel (Generated_ShallowShared.StepParam.acc\<^sub>f x) (Generated_ShallowShared_Tuples.StepParam.acc\<^sub>f xt)"
  by (simp add: shallow_tuples_rel_StepParam_def)
lemma shallow_tuples_rule__StepParam__obsv\<^sub>f [ShallowTuplesThms_Generated]:
  "shallow_tuples_rel (x :: ('x1, 'x2) Generated_ShallowShared.StepParam) (xt :: ('xt1, 'xt2) Generated_ShallowShared_Tuples.StepParam) \<Longrightarrow>
   shallow_tuples_rel (Generated_ShallowShared.StepParam.obsv\<^sub>f x) (Generated_ShallowShared_Tuples.StepParam.obsv\<^sub>f xt)"
  by (simp add: shallow_tuples_rel_StepParam_def)
lemma shallow_tuples_rule__StepParam__acc\<^sub>f__update [ShallowTuplesRules_Generated]:
  "\<lbrakk> shallow_tuples_rel (x :: ('x1, 'x2) Generated_ShallowShared.StepParam) (xt :: ('xt1, 'xt2) Generated_ShallowShared_Tuples.StepParam);
     shallow_tuples_rel v vt
   \<rbrakk> \<Longrightarrow>
   shallow_tuples_rel (Generated_ShallowShared.StepParam.acc\<^sub>f_update (\<lambda>_. v) x) (Generated_ShallowShared_Tuples.StepParam.acc\<^sub>f_update (\<lambda>_. vt) xt)"
  by (simp add: shallow_tuples_rel_StepParam_def)
lemma shallow_tuples_rule__StepParam__obsv\<^sub>f__update [ShallowTuplesRules_Generated]:
  "\<lbrakk> shallow_tuples_rel (x :: ('x1, 'x2) Generated_ShallowShared.StepParam) (xt :: ('xt1, 'xt2) Generated_ShallowShared_Tuples.StepParam);
     shallow_tuples_rel v vt
   \<rbrakk> \<Longrightarrow>
   shallow_tuples_rel (Generated_ShallowShared.StepParam.obsv\<^sub>f_update (\<lambda>_. v) x) (Generated_ShallowShared_Tuples.StepParam.obsv\<^sub>f_update (\<lambda>_. vt) xt)"
  by (simp add: shallow_tuples_rel_StepParam_def)


overloading shallow_tuples_rel_WordArrayGetP \<equiv> shallow_tuples_rel begin
  definition "shallow_tuples_rel_WordArrayGetP (x :: ('x1, 'x2, 'x3) Generated_ShallowShared.WordArrayGetP) (xt :: ('xt1, 'xt2, 'xt3) Generated_ShallowShared_Tuples.WordArrayGetP) \<equiv>
    shallow_tuples_rel (Generated_ShallowShared.WordArrayGetP.arr\<^sub>f x) (Generated_ShallowShared_Tuples.WordArrayGetP.arr\<^sub>f xt) \<and>
    shallow_tuples_rel (Generated_ShallowShared.WordArrayGetP.idx\<^sub>f x) (Generated_ShallowShared_Tuples.WordArrayGetP.idx\<^sub>f xt) \<and>
    shallow_tuples_rel (Generated_ShallowShared.WordArrayGetP.val\<^sub>f x) (Generated_ShallowShared_Tuples.WordArrayGetP.val\<^sub>f xt)"
end
lemma shallow_tuples_rule_make__WordArrayGetP [ShallowTuplesRules_Generated]:
  "\<lbrakk>
     shallow_tuples_rel x1 xt1;
     shallow_tuples_rel x2 xt2;
     shallow_tuples_rel x3 xt3
  \<rbrakk> \<Longrightarrow> shallow_tuples_rel (Generated_ShallowShared.WordArrayGetP.make x1 x2 x3) \<lparr>Generated_ShallowShared_Tuples.WordArrayGetP.arr\<^sub>f = xt1, idx\<^sub>f = xt2 , val\<^sub>f = xt3\<rparr>"
  by (simp add: shallow_tuples_rel_WordArrayGetP_def Generated_ShallowShared.WordArrayGetP.defs Generated_ShallowShared_Tuples.WordArrayGetP.defs)
lemma shallow_tuples_rule__WordArrayGetP__arr\<^sub>f [ShallowTuplesThms_Generated]:
  "shallow_tuples_rel (x :: ('x1, 'x2, 'x3) Generated_ShallowShared.WordArrayGetP) (xt :: ('xt1, 'xt2, 'xt3) Generated_ShallowShared_Tuples.WordArrayGetP) \<Longrightarrow>
   shallow_tuples_rel (Generated_ShallowShared.WordArrayGetP.arr\<^sub>f x) (Generated_ShallowShared_Tuples.WordArrayGetP.arr\<^sub>f xt)"
  by (simp add: shallow_tuples_rel_WordArrayGetP_def)
lemma shallow_tuples_rule__WordArrayGetP__idx\<^sub>f [ShallowTuplesThms_Generated]:
  "shallow_tuples_rel (x :: ('x1, 'x2, 'x3) Generated_ShallowShared.WordArrayGetP) (xt :: ('xt1, 'xt2, 'xt3) Generated_ShallowShared_Tuples.WordArrayGetP) \<Longrightarrow>
   shallow_tuples_rel (Generated_ShallowShared.WordArrayGetP.idx\<^sub>f x) (Generated_ShallowShared_Tuples.WordArrayGetP.idx\<^sub>f xt)"
  by (simp add: shallow_tuples_rel_WordArrayGetP_def)
lemma shallow_tuples_rule__WordArrayGetP__val\<^sub>f [ShallowTuplesThms_Generated]:
  "shallow_tuples_rel (x :: ('x1, 'x2, 'x3) Generated_ShallowShared.WordArrayGetP) (xt :: ('xt1, 'xt2, 'xt3) Generated_ShallowShared_Tuples.WordArrayGetP) \<Longrightarrow>
   shallow_tuples_rel (Generated_ShallowShared.WordArrayGetP.val\<^sub>f x) (Generated_ShallowShared_Tuples.WordArrayGetP.val\<^sub>f xt)"
  by (simp add: shallow_tuples_rel_WordArrayGetP_def)
lemma shallow_tuples_rule__WordArrayGetP__arr\<^sub>f__update [ShallowTuplesRules_Generated]:
  "\<lbrakk> shallow_tuples_rel (x :: ('x1, 'x2, 'x3) Generated_ShallowShared.WordArrayGetP) (xt :: ('xt1, 'xt2, 'xt3) Generated_ShallowShared_Tuples.WordArrayGetP);
     shallow_tuples_rel v vt
   \<rbrakk> \<Longrightarrow>
   shallow_tuples_rel (Generated_ShallowShared.WordArrayGetP.arr\<^sub>f_update (\<lambda>_. v) x) (Generated_ShallowShared_Tuples.WordArrayGetP.arr\<^sub>f_update (\<lambda>_. vt) xt)"
  by (simp add: shallow_tuples_rel_WordArrayGetP_def)
lemma shallow_tuples_rule__WordArrayGetP__idx\<^sub>f__update [ShallowTuplesRules_Generated]:
  "\<lbrakk> shallow_tuples_rel (x :: ('x1, 'x2, 'x3) Generated_ShallowShared.WordArrayGetP) (xt :: ('xt1, 'xt2, 'xt3) Generated_ShallowShared_Tuples.WordArrayGetP);
     shallow_tuples_rel v vt
   \<rbrakk> \<Longrightarrow>
   shallow_tuples_rel (Generated_ShallowShared.WordArrayGetP.idx\<^sub>f_update (\<lambda>_. v) x) (Generated_ShallowShared_Tuples.WordArrayGetP.idx\<^sub>f_update (\<lambda>_. vt) xt)"
  by (simp add: shallow_tuples_rel_WordArrayGetP_def)
lemma shallow_tuples_rule__WordArrayGetP__val\<^sub>f__update [ShallowTuplesRules_Generated]:
  "\<lbrakk> shallow_tuples_rel (x :: ('x1, 'x2, 'x3) Generated_ShallowShared.WordArrayGetP) (xt :: ('xt1, 'xt2, 'xt3) Generated_ShallowShared_Tuples.WordArrayGetP);
     shallow_tuples_rel v vt
   \<rbrakk> \<Longrightarrow>
   shallow_tuples_rel (Generated_ShallowShared.WordArrayGetP.val\<^sub>f_update (\<lambda>_. v) x) (Generated_ShallowShared_Tuples.WordArrayGetP.val\<^sub>f_update (\<lambda>_. vt) xt)"
  by (simp add: shallow_tuples_rel_WordArrayGetP_def)


overloading shallow_tuples_rel_RepParam \<equiv> shallow_tuples_rel begin
  definition "shallow_tuples_rel_RepParam (x :: ('x1, 'x2, 'x3, 'x4, 'x5) Generated_ShallowShared.RepParam) (xt :: ('xt1, 'xt2, 'xt3, 'xt4, 'xt5) Generated_ShallowShared_Tuples.RepParam) \<equiv>
    shallow_tuples_rel (Generated_ShallowShared.RepParam.n\<^sub>f x) (Generated_ShallowShared_Tuples.RepParam.n\<^sub>f xt) \<and>
    shallow_tuples_rel (Generated_ShallowShared.RepParam.stop\<^sub>f x) (Generated_ShallowShared_Tuples.RepParam.stop\<^sub>f xt) \<and>
    shallow_tuples_rel (Generated_ShallowShared.RepParam.step\<^sub>f x) (Generated_ShallowShared_Tuples.RepParam.step\<^sub>f xt) \<and>
    shallow_tuples_rel (Generated_ShallowShared.RepParam.acc\<^sub>f x) (Generated_ShallowShared_Tuples.RepParam.acc\<^sub>f xt) \<and>
    shallow_tuples_rel (Generated_ShallowShared.RepParam.obsv\<^sub>f x) (Generated_ShallowShared_Tuples.RepParam.obsv\<^sub>f xt)"
end
lemma shallow_tuples_rule_make__RepParam [ShallowTuplesRules_Generated]:
  "\<lbrakk>
     shallow_tuples_rel x1 xt1;
     shallow_tuples_rel x2 xt2;
     shallow_tuples_rel x3 xt3;
     shallow_tuples_rel x4 xt4;
     shallow_tuples_rel x5 xt5
  \<rbrakk> \<Longrightarrow> shallow_tuples_rel (Generated_ShallowShared.RepParam.make x1 x2 x3 x4 x5) \<lparr>Generated_ShallowShared_Tuples.RepParam.n\<^sub>f = xt1, stop\<^sub>f = xt2 , step\<^sub>f = xt3 , acc\<^sub>f = xt4 , obsv\<^sub>f = xt5\<rparr>"
  by (simp add: shallow_tuples_rel_RepParam_def Generated_ShallowShared.RepParam.defs Generated_ShallowShared_Tuples.RepParam.defs)
lemma shallow_tuples_rule__RepParam__n\<^sub>f [ShallowTuplesThms_Generated]:
  "shallow_tuples_rel (x :: ('x1, 'x2, 'x3, 'x4, 'x5) Generated_ShallowShared.RepParam) (xt :: ('xt1, 'xt2, 'xt3, 'xt4, 'xt5) Generated_ShallowShared_Tuples.RepParam) \<Longrightarrow>
   shallow_tuples_rel (Generated_ShallowShared.RepParam.n\<^sub>f x) (Generated_ShallowShared_Tuples.RepParam.n\<^sub>f xt)"
  by (simp add: shallow_tuples_rel_RepParam_def)
lemma shallow_tuples_rule__RepParam__stop\<^sub>f [ShallowTuplesThms_Generated]:
  "shallow_tuples_rel (x :: ('x1, 'x2, 'x3, 'x4, 'x5) Generated_ShallowShared.RepParam) (xt :: ('xt1, 'xt2, 'xt3, 'xt4, 'xt5) Generated_ShallowShared_Tuples.RepParam) \<Longrightarrow>
   shallow_tuples_rel (Generated_ShallowShared.RepParam.stop\<^sub>f x) (Generated_ShallowShared_Tuples.RepParam.stop\<^sub>f xt)"
  by (simp add: shallow_tuples_rel_RepParam_def)
lemma shallow_tuples_rule__RepParam__step\<^sub>f [ShallowTuplesThms_Generated]:
  "shallow_tuples_rel (x :: ('x1, 'x2, 'x3, 'x4, 'x5) Generated_ShallowShared.RepParam) (xt :: ('xt1, 'xt2, 'xt3, 'xt4, 'xt5) Generated_ShallowShared_Tuples.RepParam) \<Longrightarrow>
   shallow_tuples_rel (Generated_ShallowShared.RepParam.step\<^sub>f x) (Generated_ShallowShared_Tuples.RepParam.step\<^sub>f xt)"
  by (simp add: shallow_tuples_rel_RepParam_def)
lemma shallow_tuples_rule__RepParam__acc\<^sub>f [ShallowTuplesThms_Generated]:
  "shallow_tuples_rel (x :: ('x1, 'x2, 'x3, 'x4, 'x5) Generated_ShallowShared.RepParam) (xt :: ('xt1, 'xt2, 'xt3, 'xt4, 'xt5) Generated_ShallowShared_Tuples.RepParam) \<Longrightarrow>
   shallow_tuples_rel (Generated_ShallowShared.RepParam.acc\<^sub>f x) (Generated_ShallowShared_Tuples.RepParam.acc\<^sub>f xt)"
  by (simp add: shallow_tuples_rel_RepParam_def)
lemma shallow_tuples_rule__RepParam__obsv\<^sub>f [ShallowTuplesThms_Generated]:
  "shallow_tuples_rel (x :: ('x1, 'x2, 'x3, 'x4, 'x5) Generated_ShallowShared.RepParam) (xt :: ('xt1, 'xt2, 'xt3, 'xt4, 'xt5) Generated_ShallowShared_Tuples.RepParam) \<Longrightarrow>
   shallow_tuples_rel (Generated_ShallowShared.RepParam.obsv\<^sub>f x) (Generated_ShallowShared_Tuples.RepParam.obsv\<^sub>f xt)"
  by (simp add: shallow_tuples_rel_RepParam_def)
lemma shallow_tuples_rule__RepParam__n\<^sub>f__update [ShallowTuplesRules_Generated]:
  "\<lbrakk> shallow_tuples_rel (x :: ('x1, 'x2, 'x3, 'x4, 'x5) Generated_ShallowShared.RepParam) (xt :: ('xt1, 'xt2, 'xt3, 'xt4, 'xt5) Generated_ShallowShared_Tuples.RepParam);
     shallow_tuples_rel v vt
   \<rbrakk> \<Longrightarrow>
   shallow_tuples_rel (Generated_ShallowShared.RepParam.n\<^sub>f_update (\<lambda>_. v) x) (Generated_ShallowShared_Tuples.RepParam.n\<^sub>f_update (\<lambda>_. vt) xt)"
  by (simp add: shallow_tuples_rel_RepParam_def)
lemma shallow_tuples_rule__RepParam__stop\<^sub>f__update [ShallowTuplesRules_Generated]:
  "\<lbrakk> shallow_tuples_rel (x :: ('x1, 'x2, 'x3, 'x4, 'x5) Generated_ShallowShared.RepParam) (xt :: ('xt1, 'xt2, 'xt3, 'xt4, 'xt5) Generated_ShallowShared_Tuples.RepParam);
     shallow_tuples_rel v vt
   \<rbrakk> \<Longrightarrow>
   shallow_tuples_rel (Generated_ShallowShared.RepParam.stop\<^sub>f_update (\<lambda>_. v) x) (Generated_ShallowShared_Tuples.RepParam.stop\<^sub>f_update (\<lambda>_. vt) xt)"
  by (simp add: shallow_tuples_rel_RepParam_def)
lemma shallow_tuples_rule__RepParam__step\<^sub>f__update [ShallowTuplesRules_Generated]:
  "\<lbrakk> shallow_tuples_rel (x :: ('x1, 'x2, 'x3, 'x4, 'x5) Generated_ShallowShared.RepParam) (xt :: ('xt1, 'xt2, 'xt3, 'xt4, 'xt5) Generated_ShallowShared_Tuples.RepParam);
     shallow_tuples_rel v vt
   \<rbrakk> \<Longrightarrow>
   shallow_tuples_rel (Generated_ShallowShared.RepParam.step\<^sub>f_update (\<lambda>_. v) x) (Generated_ShallowShared_Tuples.RepParam.step\<^sub>f_update (\<lambda>_. vt) xt)"
  by (simp add: shallow_tuples_rel_RepParam_def)
lemma shallow_tuples_rule__RepParam__acc\<^sub>f__update [ShallowTuplesRules_Generated]:
  "\<lbrakk> shallow_tuples_rel (x :: ('x1, 'x2, 'x3, 'x4, 'x5) Generated_ShallowShared.RepParam) (xt :: ('xt1, 'xt2, 'xt3, 'xt4, 'xt5) Generated_ShallowShared_Tuples.RepParam);
     shallow_tuples_rel v vt
   \<rbrakk> \<Longrightarrow>
   shallow_tuples_rel (Generated_ShallowShared.RepParam.acc\<^sub>f_update (\<lambda>_. v) x) (Generated_ShallowShared_Tuples.RepParam.acc\<^sub>f_update (\<lambda>_. vt) xt)"
  by (simp add: shallow_tuples_rel_RepParam_def)
lemma shallow_tuples_rule__RepParam__obsv\<^sub>f__update [ShallowTuplesRules_Generated]:
  "\<lbrakk> shallow_tuples_rel (x :: ('x1, 'x2, 'x3, 'x4, 'x5) Generated_ShallowShared.RepParam) (xt :: ('xt1, 'xt2, 'xt3, 'xt4, 'xt5) Generated_ShallowShared_Tuples.RepParam);
     shallow_tuples_rel v vt
   \<rbrakk> \<Longrightarrow>
   shallow_tuples_rel (Generated_ShallowShared.RepParam.obsv\<^sub>f_update (\<lambda>_. v) x) (Generated_ShallowShared_Tuples.RepParam.obsv\<^sub>f_update (\<lambda>_. vt) xt)"
  by (simp add: shallow_tuples_rel_RepParam_def)


overloading shallow_tuples_rel_T0 \<equiv> shallow_tuples_rel begin
  definition "shallow_tuples_rel_T0 (x :: ('x1, 'x2) Generated_ShallowShared.T0) (xt :: 'xt1 \<times> 'xt2) \<equiv>
    shallow_tuples_rel (Generated_ShallowShared.T0.p1\<^sub>f x) (prod.fst xt) \<and>
    shallow_tuples_rel (Generated_ShallowShared.T0.p2\<^sub>f x) (prod.snd xt)"
end
lemma shallow_tuples_rule__T0_make [ShallowTuplesRules_Generated]:
  "\<lbrakk>
     shallow_tuples_rel x1 xt1;
     shallow_tuples_rel x2 xt2
  \<rbrakk> \<Longrightarrow> shallow_tuples_rel (Generated_ShallowShared.T0.make x1 x2) (xt1, xt2)"
  by (simp add: shallow_tuples_rel_T0_def Generated_ShallowShared.T0.defs Px_px)
lemma shallow_tuples_rule__T0__p1\<^sub>f [ShallowTuplesThms_Generated]:
  "shallow_tuples_rel (x :: ('x1, 'x2) Generated_ShallowShared.T0) (xt :: 'xt1 \<times> 'xt2) \<Longrightarrow>
   shallow_tuples_rel (Generated_ShallowShared.T0.p1\<^sub>f x) (prod.fst xt)"
  by (simp add: shallow_tuples_rel_T0_def)
lemma shallow_tuples_rule__T0__p2\<^sub>f [ShallowTuplesThms_Generated]:
  "shallow_tuples_rel (x :: ('x1, 'x2) Generated_ShallowShared.T0) (xt :: 'xt1 \<times> 'xt2) \<Longrightarrow>
   shallow_tuples_rel (Generated_ShallowShared.T0.p2\<^sub>f x) (prod.snd xt)"
  by (simp add: shallow_tuples_rel_T0_def)


lemma shallow_tuples__wordarray_get [ShallowTuplesThms_Generated]:
  "shallow_tuples_rel Generated_ShallowShared.wordarray_get Generated_ShallowShared_Tuples.wordarray_get"
  sorry


lemma shallow_tuples__wordarray_length [ShallowTuplesThms_Generated]:
  "shallow_tuples_rel Generated_ShallowShared.wordarray_length Generated_ShallowShared_Tuples.wordarray_length"
  sorry


lemma shallow_tuples__wordarray_put [ShallowTuplesThms_Generated]:
  "shallow_tuples_rel Generated_ShallowShared.wordarray_put Generated_ShallowShared_Tuples.wordarray_put"
  sorry


lemma shallow_tuples__repeat [ShallowTuplesThms_Generated]:
  "shallow_tuples_rel Generated_ShallowShared.repeat Generated_ShallowShared_Tuples.repeat"
  sorry


lemma shallow_tuples__expstop [ShallowTuplesThms_Generated]:
  "shallow_tuples_rel Generated_Shallow_Desugar.expstop Generated_Shallow_Desugar_Tuples.expstop"
  apply (rule shallow_tuples_rel_funI)
  apply (unfold Generated_Shallow_Desugar.expstop_def Generated_Shallow_Desugar_Tuples.expstop_def id_def)
  apply ((unfold take\<^sub>c\<^sub>o\<^sub>g\<^sub>e\<^sub>n\<^sub>t_def Let\<^sub>d\<^sub>s_def Let_def split_def)?,(simp only: fst_conv snd_conv)?)
  by (assumption |
      rule shallow_tuples_basic_bucket ShallowTuplesRules_Generated
           ShallowTuplesThms_Generated ShallowTuplesThms_Generated[THEN shallow_tuples_rel_funD])+


lemma shallow_tuples__log2stop [ShallowTuplesThms_Generated]:
  "shallow_tuples_rel Generated_Shallow_Desugar.log2stop Generated_Shallow_Desugar_Tuples.log2stop"
  apply (rule shallow_tuples_rel_funI)
  apply (unfold Generated_Shallow_Desugar.log2stop_def Generated_Shallow_Desugar_Tuples.log2stop_def id_def)
  apply ((unfold take\<^sub>c\<^sub>o\<^sub>g\<^sub>e\<^sub>n\<^sub>t_def Let\<^sub>d\<^sub>s_def Let_def split_def)?,(simp only: fst_conv snd_conv)?)
  by (assumption |
      rule shallow_tuples_basic_bucket ShallowTuplesRules_Generated
           ShallowTuplesThms_Generated ShallowTuplesThms_Generated[THEN shallow_tuples_rel_funD])+


lemma shallow_tuples__searchStop [ShallowTuplesThms_Generated]:
  "shallow_tuples_rel Generated_Shallow_Desugar.searchStop Generated_Shallow_Desugar_Tuples.searchStop"
  apply (rule shallow_tuples_rel_funI)
  apply (unfold Generated_Shallow_Desugar.searchStop_def Generated_Shallow_Desugar_Tuples.searchStop_def id_def)
  apply ((unfold take\<^sub>c\<^sub>o\<^sub>g\<^sub>e\<^sub>n\<^sub>t_def Let\<^sub>d\<^sub>s_def Let_def split_def)?,(simp only: fst_conv snd_conv)?)
  by (assumption |
      rule shallow_tuples_basic_bucket ShallowTuplesRules_Generated
           ShallowTuplesThms_Generated ShallowTuplesThms_Generated[THEN shallow_tuples_rel_funD])+


lemma shallow_tuples__expstep [ShallowTuplesThms_Generated]:
  "shallow_tuples_rel Generated_Shallow_Desugar.expstep Generated_Shallow_Desugar_Tuples.expstep"
  apply (rule shallow_tuples_rel_funI)
  apply (unfold Generated_Shallow_Desugar.expstep_def Generated_Shallow_Desugar_Tuples.expstep_def id_def)
  apply ((unfold take\<^sub>c\<^sub>o\<^sub>g\<^sub>e\<^sub>n\<^sub>t_def Let\<^sub>d\<^sub>s_def Let_def split_def)?,(simp only: fst_conv snd_conv)?)
  by (assumption |
      rule shallow_tuples_basic_bucket ShallowTuplesRules_Generated
           ShallowTuplesThms_Generated ShallowTuplesThms_Generated[THEN shallow_tuples_rel_funD])+


lemma shallow_tuples__log2step [ShallowTuplesThms_Generated]:
  "shallow_tuples_rel Generated_Shallow_Desugar.log2step Generated_Shallow_Desugar_Tuples.log2step"
  apply (rule shallow_tuples_rel_funI)
  apply (unfold Generated_Shallow_Desugar.log2step_def Generated_Shallow_Desugar_Tuples.log2step_def id_def)
  apply ((unfold take\<^sub>c\<^sub>o\<^sub>g\<^sub>e\<^sub>n\<^sub>t_def Let\<^sub>d\<^sub>s_def Let_def split_def)?,(simp only: fst_conv snd_conv)?)
  by (assumption |
      rule shallow_tuples_basic_bucket ShallowTuplesRules_Generated
           ShallowTuplesThms_Generated ShallowTuplesThms_Generated[THEN shallow_tuples_rel_funD])+


lemma shallow_tuples__searchNext [ShallowTuplesThms_Generated]:
  "shallow_tuples_rel Generated_Shallow_Desugar.searchNext Generated_Shallow_Desugar_Tuples.searchNext"
  apply (rule shallow_tuples_rel_funI)
  apply (unfold Generated_Shallow_Desugar.searchNext_def Generated_Shallow_Desugar_Tuples.searchNext_def id_def)
  apply ((unfold take\<^sub>c\<^sub>o\<^sub>g\<^sub>e\<^sub>n\<^sub>t_def Let\<^sub>d\<^sub>s_def Let_def split_def)?,(simp only: fst_conv snd_conv)?)
  by (assumption |
      rule shallow_tuples_basic_bucket ShallowTuplesRules_Generated
           ShallowTuplesThms_Generated ShallowTuplesThms_Generated[THEN shallow_tuples_rel_funD])+


lemma shallow_tuples__binarySearch [ShallowTuplesThms_Generated]:
  "shallow_tuples_rel Generated_Shallow_Desugar.binarySearch Generated_Shallow_Desugar_Tuples.binarySearch"
  apply (rule shallow_tuples_rel_funI)
  apply (unfold Generated_Shallow_Desugar.binarySearch_def Generated_Shallow_Desugar_Tuples.binarySearch_def id_def)
  apply ((unfold take\<^sub>c\<^sub>o\<^sub>g\<^sub>e\<^sub>n\<^sub>t_def Let\<^sub>d\<^sub>s_def Let_def split_def)?,(simp only: fst_conv snd_conv)?)
  by (assumption |
      rule shallow_tuples_basic_bucket ShallowTuplesRules_Generated
           ShallowTuplesThms_Generated ShallowTuplesThms_Generated[THEN shallow_tuples_rel_funD])+


lemma shallow_tuples__myexp [ShallowTuplesThms_Generated]:
  "shallow_tuples_rel Generated_Shallow_Desugar.myexp Generated_Shallow_Desugar_Tuples.myexp"
  apply (rule shallow_tuples_rel_funI)
  apply (unfold Generated_Shallow_Desugar.myexp_def Generated_Shallow_Desugar_Tuples.myexp_def id_def)
  apply ((unfold take\<^sub>c\<^sub>o\<^sub>g\<^sub>e\<^sub>n\<^sub>t_def Let\<^sub>d\<^sub>s_def Let_def split_def)?,(simp only: fst_conv snd_conv)?)
  by (assumption |
      rule shallow_tuples_basic_bucket ShallowTuplesRules_Generated
           ShallowTuplesThms_Generated ShallowTuplesThms_Generated[THEN shallow_tuples_rel_funD])+


lemma shallow_tuples__mylog2 [ShallowTuplesThms_Generated]:
  "shallow_tuples_rel Generated_Shallow_Desugar.mylog2 Generated_Shallow_Desugar_Tuples.mylog2"
  apply (rule shallow_tuples_rel_funI)
  apply (unfold Generated_Shallow_Desugar.mylog2_def Generated_Shallow_Desugar_Tuples.mylog2_def id_def)
  apply ((unfold take\<^sub>c\<^sub>o\<^sub>g\<^sub>e\<^sub>n\<^sub>t_def Let\<^sub>d\<^sub>s_def Let_def split_def)?,(simp only: fst_conv snd_conv)?)
  by (assumption |
      rule shallow_tuples_basic_bucket ShallowTuplesRules_Generated
           ShallowTuplesThms_Generated ShallowTuplesThms_Generated[THEN shallow_tuples_rel_funD])+


end
