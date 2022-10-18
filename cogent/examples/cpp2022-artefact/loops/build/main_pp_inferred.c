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
typedef struct u1_t {
            u8 uint;
        } u1_t;
typedef struct u2_t {
            u8 uint;
        } u2_t;
typedef struct u3_t {
            u8 uint;
        } u3_t;
typedef struct u4_t {
            u8 uint;
        } u4_t;
typedef struct u5_t {
            u8 uint;
        } u5_t;
typedef struct u6_t {
            u8 uint;
        } u6_t;
typedef struct u7_t {
            u8 uint;
        } u7_t;
typedef struct u9_t {
            u16 uint;
        } u9_t;
typedef struct u10_t {
            u16 uint;
        } u10_t;
typedef struct u11_t {
            u16 uint;
        } u11_t;
typedef struct u12_t {
            u16 uint;
        } u12_t;
typedef struct u13_t {
            u16 uint;
        } u13_t;
typedef struct u14_t {
            u16 uint;
        } u14_t;
typedef struct u15_t {
            u16 uint;
        } u15_t;
typedef struct u17_t {
            u32 uint;
        } u17_t;
typedef struct u18_t {
            u32 uint;
        } u18_t;
typedef struct u19_t {
            u32 uint;
        } u19_t;
typedef struct u20_t {
            u32 uint;
        } u20_t;
typedef struct u21_t {
            u32 uint;
        } u21_t;
typedef struct u22_t {
            u32 uint;
        } u22_t;
typedef struct u23_t {
            u32 uint;
        } u23_t;
typedef struct u24_t {
            u32 uint;
        } u24_t;
typedef struct u25_t {
            u32 uint;
        } u25_t;
typedef struct u26_t {
            u32 uint;
        } u26_t;
typedef struct u27_t {
            u32 uint;
        } u27_t;
typedef struct u28_t {
            u32 uint;
        } u28_t;
typedef struct u29_t {
            u32 uint;
        } u29_t;
typedef struct u30_t {
            u32 uint;
        } u30_t;
typedef struct u31_t {
            u32 uint;
        } u31_t;
typedef struct u33_t {
            u64 uint;
        } u33_t;
typedef struct u34_t {
            u64 uint;
        } u34_t;
typedef struct u35_t {
            u64 uint;
        } u35_t;
typedef struct u36_t {
            u64 uint;
        } u36_t;
typedef struct u37_t {
            u64 uint;
        } u37_t;
typedef struct u38_t {
            u64 uint;
        } u38_t;
typedef struct u39_t {
            u64 uint;
        } u39_t;
typedef struct u40_t {
            u64 uint;
        } u40_t;
typedef struct u41_t {
            u64 uint;
        } u41_t;
typedef struct u42_t {
            u64 uint;
        } u42_t;
typedef struct u43_t {
            u64 uint;
        } u43_t;
typedef struct u44_t {
            u64 uint;
        } u44_t;
typedef struct u45_t {
            u64 uint;
        } u45_t;
typedef struct u46_t {
            u64 uint;
        } u46_t;
typedef struct u47_t {
            u64 uint;
        } u47_t;
typedef struct u48_t {
            u64 uint;
        } u48_t;
typedef struct u49_t {
            u64 uint;
        } u49_t;
typedef struct u50_t {
            u64 uint;
        } u50_t;
typedef struct u51_t {
            u64 uint;
        } u51_t;
typedef struct u52_t {
            u64 uint;
        } u52_t;
typedef struct u53_t {
            u64 uint;
        } u53_t;
typedef struct u54_t {
            u64 uint;
        } u54_t;
typedef struct u55_t {
            u64 uint;
        } u55_t;
typedef struct u56_t {
            u64 uint;
        } u56_t;
typedef struct u57_t {
            u64 uint;
        } u57_t;
typedef struct u58_t {
            u64 uint;
        } u58_t;
typedef struct u59_t {
            u64 uint;
        } u59_t;
typedef struct u60_t {
            u64 uint;
        } u60_t;
typedef struct u61_t {
            u64 uint;
        } u61_t;
typedef struct u62_t {
            u64 uint;
        } u62_t;
typedef struct u63_t {
            u64 uint;
        } u63_t;
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
    return 0 ? v : swap_u16(v);
}
static inline u32 be_u32_swap(u32 v)
{
    return 0 ? v : swap_u32(v);
}
static inline u64 be_u64_swap(u64 v)
{
    return 0 ? v : swap_u64(v);
}
static inline u8 le_u8_swap(u8 v)
{
    return v;
}
static inline u16 le_u16_swap(u16 v)
{
    return 0 ? swap_u16(v) : v;
}
static inline u32 le_u32_swap(u32 v)
{
    return 0 ? swap_u32(v) : v;
}
static inline u64 le_u64_swap(u64 v)
{
    return 0 ? swap_u64(v) : v;
}
enum {
    LET_TRUE = 1,
};
enum {
    LETBANG_TRUE = 1,
};
enum tag_t {
    TAG_ENUM_Nothing,
    TAG_ENUM_Something,
};
typedef enum tag_t tag_t;
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
    FUN_ENUM_wordarray_get_opt32,
    FUN_ENUM_wordarray_get_opt_0,
    FUN_ENUM_wordarray_length_0,
    FUN_ENUM_wordarray_put32,
    FUN_ENUM_wordarray_put_0,
};
typedef enum untyped_func_enum untyped_func_enum;
typedef untyped_func_enum t20;
typedef untyped_func_enum t21;
typedef untyped_func_enum t22;
typedef untyped_func_enum t23;
typedef untyped_func_enum t14;
typedef untyped_func_enum t15;
typedef untyped_func_enum t24;
typedef untyped_func_enum t25;
typedef untyped_func_enum t26;
typedef untyped_func_enum t4;
typedef untyped_func_enum t5;
typedef untyped_func_enum t27;
typedef untyped_func_enum t28;
typedef untyped_func_enum t10;
typedef untyped_func_enum t11;
typedef untyped_func_enum t29;
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
typedef struct t17 t17;
typedef struct t18 t18;
typedef struct t19 t19;
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
    bool_t p3;
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
struct t17 {
    WordArray_u32 *arr;
    u32 idx;
};
struct t18 {
    tag_t tag;
    unit_t Nothing;
    u32 Something;
};
struct t19 {
    u32 p1;
    u32 p2;
};
static inline u32 wordarray_get_0(t1);
static inline u32 wordarray_length_0(WordArray_u32 *);
static inline WordArray_u32 *wordarray_put_0(t1);
static inline t2 repeat_0(t6);
static inline t7 repeat_2(t12);
static inline u32 repeat_1(t16);
static inline t18 wordarray_get_opt_0(t17);
static inline WordArray_u32 *wordarray_put32(t1);
static inline bool_t expstop(t13);
static inline bool_t log2stop(t3);
static inline bool_t searchStop(t9);
static inline u32 expstep(t13);
static inline t2 log2step(t3);
static inline t7 searchNext(t9);
static inline u32 binarySearch(t8);
static inline u32 myexp(t19);
static inline u64 mylog2(u64);
static inline t18 wordarray_get_opt32(t17);
static inline u32 dispatch_t20(untyped_func_enum a2, WordArray_u32 *a3)
{
    return wordarray_length_0(a3);
}
static inline WordArray_u32 *dispatch_t21(untyped_func_enum a2, t1 a3)
{
    switch (a2) {
        
      case FUN_ENUM_wordarray_put32:
        return wordarray_put32(a3);
        
      default:
        return wordarray_put_0(a3);
    }
}
static inline u32 dispatch_t22(untyped_func_enum a2, t1 a3)
{
    return wordarray_get_0(a3);
}
static inline t7 dispatch_t23(untyped_func_enum a2, t12 a3)
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
static inline u32 dispatch_t24(untyped_func_enum a2, t16 a3)
{
    return repeat_1(a3);
}
static inline t18 dispatch_t25(untyped_func_enum a2, t17 a3)
{
    switch (a2) {
        
      case FUN_ENUM_wordarray_get_opt32:
        return wordarray_get_opt32(a3);
        
      default:
        return wordarray_get_opt_0(a3);
    }
}
static inline u32 dispatch_t26(untyped_func_enum a2, t19 a3)
{
    return myexp(a3);
}
static inline bool_t dispatch_t4(untyped_func_enum a2, t3 a3)
{
    return log2stop(a3);
}
static inline t2 dispatch_t5(untyped_func_enum a2, t3 a3)
{
    return log2step(a3);
}
static inline t2 dispatch_t27(untyped_func_enum a2, t6 a3)
{
    return repeat_0(a3);
}
static inline u32 dispatch_t28(untyped_func_enum a2, t8 a3)
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
static inline u64 dispatch_t29(untyped_func_enum a2, u64 a3)
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
typedef t19 myexp_arg;
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
typedef t17 wordarray_get_opt32_arg;
typedef t18 wordarray_get_opt32_ret;
typedef t17 wordarray_get_opt_0_arg;
typedef t18 wordarray_get_opt_0_ret;
typedef WordArray_u32 *wordarray_length_0_arg;
typedef u32 wordarray_length_0_ret;
typedef t1 wordarray_put32_arg;
typedef WordArray_u32 *wordarray_put32_ret;
typedef t1 wordarray_put_0_arg;
typedef WordArray_u32 *wordarray_put_0_ret;
static inline WordArray_u32 *wordarray_put32(t1 a1)
{
    t1 r2 = a1;
    WordArray_u32 *r3 = wordarray_put_0(r2);
    
    return r3;
}
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
    bool_t r6 = r2.p3;
    bool_t r7;
    
    if (r6.boolean)
        r7 = (bool_t) {.boolean = 1U};
    else {
        bool_t r8 = (bool_t) {.boolean = r4 >= r5};
        bool_t r9;
        
        if (r8.boolean)
            r9 = (bool_t) {.boolean = 1U};
        else
            r9 = (bool_t) {.boolean = 0U};
        r7 = r9;
    }
    
    bool_t r10 = r7;
    
    return r10;
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
    bool_t r6 = r2.p3;
    WordArray_u32 *r7 = r3.p1;
    u32 r8 = r3.p2;
    u32 r9 = r5 - r4;
    u32 r10 = 2U;
    u32 r11 = r10 ? r9 / r10 : 0U;
    u32 r12 = r4 + r11;
    u32 r13 = 0U;
    t1 r14 = (t1) {.arr = r7, .idx = r12, .val = r13};
    u32 r15 = wordarray_get_0(r14);
    bool_t r16 = (bool_t) {.boolean = r15 < r8};
    t7 r17;
    
    if (r16.boolean) {
        u32 r18 = 1U;
        u32 r19 = r12 + r18;
        
        r17 = (t7) {.p1 = r19, .p2 = r5, .p3 = r6};
    } else {
        bool_t r20 = (bool_t) {.boolean = r15 > r8};
        t7 r21;
        
        if (r20.boolean)
            r21 = (t7) {.p1 = r4, .p2 = r12, .p3 = r6};
        else {
            bool_t r22 = (bool_t) {.boolean = 1U};
            
            r21 = (t7) {.p1 = r12, .p2 = r5, .p3 = r22};
        }
        r17 = r21;
    }
    
    t7 r23 = r17;
    
    return r23;
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
    bool_t r9 = (bool_t) {.boolean = 0U};
    t7 r10 = (t7) {.p1 = r8, .p2 = r4, .p3 = r9};
    t8 r11 = (t8) {.p1 = r2, .p2 = r3};
    t12 r12 = (t12) {.n = r5, .stop = r6, .step = r7, .acc = r10, .obsv = r11};
    t7 r13 = repeat_2(r12);
    u32 r14 = r13.p1;
    u32 r15 = r13.p2;
    bool_t r16 = r13.p3;
    u32 r17;
    
    if (r16.boolean)
        r17 = r14;
    else
        r17 = r4;
    
    u32 r18 = r17;
    
    return r18;
}
static inline u32 myexp(t19 a1)
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
static inline t18 wordarray_get_opt32(t17 a1)
{
    t17 r2 = a1;
    t18 r3 = wordarray_get_opt_0(r2);
    
    return r3;
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
WordArray_u32 *wordarray_put_0(t1 args)
{
    if (__builtin_expect(!!(args.idx < args.arr->len), 1))
        args.arr->values[args.idx] = args.val;
    return args.arr;
}
t18 wordarray_get_opt_0(t17 args)
{
    t18 ret;
    
    if (args.idx >= args.arr->len)
        ret.tag = TAG_ENUM_Nothing;
    else {
        ret.tag = TAG_ENUM_Something;
        ret.Something = args.arr->values[args.idx];
    }
    return ret;
}

