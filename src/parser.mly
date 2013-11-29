/**************************************************************************/
/*                        Lem                                             */
/*                                                                        */
/*          Dominic Mulligan, University of Cambridge                     */
/*          Francesco Zappa Nardelli, INRIA Paris-Rocquencourt            */
/*          Gabriel Kerneis, University of Cambridge                      */
/*          Kathy Gray, University of Cambridge                           */
/*          Peter Boehm, University of Cambridge (while working on Lem)   */
/*          Peter Sewell, University of Cambridge                         */
/*          Scott Owens, University of Kent                               */
/*          Thomas Tuerk, University of Cambridge                         */
/*                                                                        */
/*  The Lem sources are copyright 2010-2013                               */
/*  by the UK authors above and Institut National de Recherche en         */
/*  Informatique et en Automatique (INRIA).                               */
/*                                                                        */
/*  All files except ocaml-lib/pmap.{ml,mli} and ocaml-libpset.{ml,mli}   */
/*  are distributed under the license below.  The former are distributed  */
/*  under the LGPLv2, as in the LICENSE file.                             */
/*                                                                        */
/*                                                                        */
/*  Redistribution and use in source and binary forms, with or without    */
/*  modification, are permitted provided that the following conditions    */
/*  are met:                                                              */
/*  1. Redistributions of source code must retain the above copyright     */
/*  notice, this list of conditions and the following disclaimer.         */
/*  2. Redistributions in binary form must reproduce the above copyright  */
/*  notice, this list of conditions and the following disclaimer in the   */
/*  documentation and/or other materials provided with the distribution.  */
/*  3. The names of the authors may not be used to endorse or promote     */
/*  products derived from this software without specific prior written    */
/*  permission.                                                           */
/*                                                                        */
/*  THIS SOFTWARE IS PROVIDED BY THE AUTHORS ``AS IS'' AND ANY EXPRESS    */
/*  OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED     */
/*  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE    */
/*  ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY       */
/*  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL    */
/*  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE     */
/*  GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS         */
/*  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER  */
/*  IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR       */
/*  OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN   */
/*  IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.                         */
/**************************************************************************/

%{

let r = fun x -> x (* Ulib.Text.of_latin1 *)

open Parse_ast

let loc () = Range(Parsing.symbol_start_pos(),Parsing.symbol_end_pos())
let locn m n = Range(Parsing.rhs_start_pos m,Parsing.rhs_end_pos n)

let idl i = Id_aux(i, loc())

let ploc p = P_aux(p,loc ())
let eloc e = E_aux(e,loc ())
let peloc pe = Pat_aux(pe,loc ())
let lbloc lb = LB_aux(lb,loc ())

let bkloc k = BK_aux(k,loc ())
let kloc k = K_aux(k,loc ())
let kiloc ki = KOpt_aux(ki,loc ())
let tloc t = ATyp_aux(t,loc ())
let lloc l = L_aux(l,loc ())
let ploc p = P_aux(p,loc ())
let fploc p = FP_aux(p,loc ())

let funclloc f = FCL_aux(f,loc ())
let typql t = TypQ_aux(t, loc())
let irloc r = BF_aux(r, loc())
let defloc df = DT_aux(df, loc())

let tdloc td = TD_aux(td, loc())
let funloc fn = FD_aux(fn, loc())
let vloc v = VS_aux(v, loc ())
let dloc d = DEF_aux(d,loc ())

let mk_typschm tq t s e = TypSchm_aux((TypSchm_ts(tq,t)),(locn s e))
let mk_rec i = (Rec_aux((Rec_rec), locn i i))
let mk_recn _ = (Rec_aux((Rec_nonrec), Unknown))
let mk_typqn _ = (TypQ_aux(TypQ_no_forall,Unknown))
let mk_tannot tq t s e = Typ_annot_opt_aux(Typ_annot_opt_some(tq,t),(locn s e))
let mk_tannotn _ = Typ_annot_opt_aux(Typ_annot_opt_none,Unknown)
let mk_eannot e i = Effects_opt_aux((Effects_opt_effects(e)),(locn i i))
let mk_eannotn _ = Effects_opt_aux(Effects_opt_pure,Unknown)
let mk_namesectn _ = Name_sect_aux(Name_sect_none,Unknown)

let make_enum_sugar_bounded typ1 typ2 =
  ATyp_app(Id_aux(Id("enum"),Unknown),
           [typ1; typ2; ATyp_aux(ATyp_inc,Unknown)])
let make_enum_sugar typ1 =
  make_enum_sugar_bounded typ1 (ATyp_aux(ATyp_constant(0), Unknown))

let make_vector_sugar_bounded typ typ1 typ2 = 
  ATyp_app(Id_aux(Id("vector"),Unknown),
           [typ1;typ2;ATyp_aux(ATyp_inc,Unknown);typ])
let make_vector_sugar typ typ1 =
  make_vector_sugar_bounded typ typ1 (ATyp_aux(ATyp_constant(0),Unknown))
    

let space = " "
let star = "*"

(*let mk_pre_x_l sk1 (sk2,id) sk3 l =
  if (sk2 = None || sk2 = Some []) && (sk3 = None || sk3 = Some []) then
    PreX_l(sk1,(None,id),None,l)
  else if (sk2 = Some [Ws space] &&
           sk3 = Some [Ws space] &&
           (Ulib.Text.left id 1 = star ||
            Ulib.Text.right id 1 = star)) then
    PreX_l(sk1,(None,id),None,l)
  else
    raise (Parse_error_locn(l, "illegal whitespace in parenthesised infix name"))*)


%}

/*Terminals with no content*/

%token And As Bits By Case Clause Const Dec Default Deinfix Effect Effects End Enumerate Else Extern
%token False Forall Foreach Function_ If_ In IN Inc Let_ Member Nat Order Pure Rec Register
%token Scattered Struct Switch Then True TwoStarStar Type TYPE Typedef Undefined Union With Val

/* Avoid shift/reduce conflict - see right_atomic_exp rule */
%nonassoc Then
%nonassoc Else

%token AND Div_ EOR Mod OR Quot Rem

%token Bar Colon Comma Dot Eof Minus Semi Under
%token Lcurly Rcurly Lparen Rparen Lsquare Rsquare
%token BarBar BarSquare BarBarSquare ColonEq DotDot ColonGt MinusGt LtBar SquareBar SquareBarBar

/*Terminals with content*/

%token <string> Id TyVar TyId
%token <int> Num
%token <string> String Bin Hex

%token <string> Amp At Carrot  Div Eq Excl Gt Lt Plus Star Tilde
%token <string> AmpAmp CarrotCarrot ColonColon EqDivEq EqEq ExclEq ExclExcl
%token <string> GtEq GtEqPlus GtGt GtGtGt GtPlus HashGtGt HashLtLt
%token <string> LtEq LtEqPlus LtGt LtLt LtLtLt LtPlus StarStar TildeCarrot

%token <string> GtEqUnderS GtEqUnderSi GtEqUnderU GtEqUnderUi GtGtUnderU GtUnderS
%token <string> GtUnderSi GtUnderU GtUnderUi LtEqUnderS LtEqUnderSi LtEqUnderU
%token <string> LtEqUnderUi LtUnderS LtUnderSi LtUnderU LtUnderUi StarStarUnderS StarStarUnderSi StarUnderS
%token <string> StarUnderSi StarUnderU StarUnderUi TwoCarrot

%token <string> AmpI AtI CarrotI  DivI EqI ExclI GtI LtI PlusI StarI TildeI
%token <string> AmpAmpI CarrotCarrotI ColonColonI EqDivEqI EqEqI ExclEqI ExclExclI
%token <string> GtEqI GtEqPlusI GtGtI GtGtGtI GtPlusI HashGtGtI HashLtLtI
%token <string> LtEqI LtEqPlusI LtGtI LtLtI LtLtLtI LtPlusI StarStarI TildeCarrotI

%token <string> GtEqUnderSI GtEqUnderSiI GtEqUnderUI GtEqUnderUiI GtGtUnderUI GtUnderSI
%token <string> GtUnderSiI GtUnderUI GtUnderUiI LtEqUnderSI LtEqUnderSiI LtEqUnderUI
%token <string> LtEqUnderUiI LtUnderSI LtUnderSiI LtUnderUI LtUnderUiI StarStarUnderSI StarStarUnderSiI StarUnderSI
%token <string> StarUnderSiI StarUnderUI StarUnderUiI TwoCarrotI

%start file
%type <Parse_ast.defs> defs
%type <Parse_ast.atyp> typ
%type <Parse_ast.pat> pat
%type <Parse_ast.exp> exp
%type <Parse_ast.defs> file


%%

id:
  | Id
    { idl (Id($1)) }
  | Tilde
    { idl (Id($1)) }
  | Lparen Deinfix Amp Rparen
    { idl (DeIid($3)) }
  | Lparen Deinfix At Rparen
    { idl (DeIid($3)) }
  | Lparen Deinfix Carrot Rparen
    { idl (DeIid($3)) }
  | Lparen Deinfix Div Rparen
    { idl (DeIid($3)) }
  | Lparen Deinfix Eq Rparen
    { Id_aux(DeIid($3),loc ()) }
  | Lparen Deinfix Excl Lparen
    { idl (DeIid($3)) }
  | Lparen Deinfix Gt Lparen
    { idl (DeIid($3)) }
  | Lparen Deinfix Lt Lparen
    { idl (DeIid($3)) }
  | Lparen Deinfix Minus Lparen
    { idl (DeIid("-")) }
  | Lparen Deinfix Plus Rparen
    { idl (DeIid($3)) }
  | Lparen Deinfix Star Rparen
    { idl (DeIid($3)) }
  | Lparen Deinfix AmpAmp Rparen
    { idl (DeIid($3)) }
  | Lparen Deinfix BarBar Rparen
    { idl (DeIid("||")) }
  | Lparen Deinfix CarrotCarrot Rparen
    { idl (DeIid($3)) }
  | Lparen Deinfix ColonColon Rparen
    { idl (DeIid($3)) }
  | Lparen Deinfix EqDivEq Rparen
    { idl (DeIid($3)) }
  | Lparen Deinfix EqEq Rparen
    { idl (DeIid($3)) }
  | Lparen Deinfix ExclEq Rparen
    { idl (DeIid($3)) }
  | Lparen Deinfix ExclExcl Rparen
    { idl (DeIid($3)) }
  | Lparen Deinfix GtEq Rparen
    { idl (DeIid($3)) }
  | Lparen Deinfix GtEqPlus Rparen
    { idl (DeIid($3)) }
  | Lparen Deinfix GtGt Rparen
    { idl (DeIid($3)) }
  | Lparen Deinfix GtGtGt Rparen
    { idl (DeIid($3)) }
  | Lparen Deinfix GtPlus Rparen
    { idl (DeIid($3)) }
  | Lparen Deinfix HashGtGt Rparen
    { idl (DeIid($3)) }
  | Lparen Deinfix HashLtLt Rparen
    { idl (DeIid($3)) }
  | Lparen Deinfix LtEq Rparen
    { idl (DeIid($3)) }
  | Lparen Deinfix LtLt Rparen
    { idl (DeIid($3)) }
  | Lparen Deinfix LtLtLt Rparen
    { idl (DeIid($3)) }
  | Lparen Deinfix LtPlus Rparen
    { idl (DeIid($3)) }
  | Lparen Deinfix StarStar Rparen
    { idl (DeIid($3)) }
  | Lparen Deinfix TildeCarrot Rparen
    { idl (DeIid($3)) }

tid:
  | TyId
    { (idl (Id($1))) }

tyvar:
  | TyVar
    { (Var_aux((Var($1)),loc ())) }

atomic_kind:
  | TYPE
    { bkloc BK_type }
  | Nat
    { bkloc BK_nat }
  | Order
    { bkloc BK_order }
  | Effects
    { bkloc BK_effects }

kind_help:
  | atomic_kind
    { [ $1 ] }
  | atomic_kind MinusGt kind_help
    { $1::$3 }

kind:
  | kind_help
    { K_aux(K_kind($1), loc ()) }

effect:
  | id
    { (match $1 with
       | Id_aux(Id(s),l) ->
	 Effect_aux
	   ((match s with
	   | "rreg" -> (Effect_rreg)
	   | "wreg" -> (Effect_wreg)
	   | "rmem" -> (Effect_rmem)
	   | "wmem" -> (Effect_wmem)
	   | "undef" -> (Effect_undef)
	   | "unspec" -> (Effect_unspec)
	   | "nondet" -> (Effect_nondet)
	   | _ -> raise (Parse_error_locn (l,"Invalid effect"))),l)
       | _ -> raise (Parse_error_locn ((loc ()),"Invalid effect"))) }

effect_list:
  | effect
    { [$1] }
  | effect Comma effect_list
    { $1::$3 }

effect_typ:
  | Effect tid
    { tloc (ATyp_efid($2)) }
  | Effect Lcurly effect_list Rcurly
    { tloc (ATyp_set($3)) }
  | Pure
    { tloc (ATyp_set([])) }

atomic_typ:
  | tid
    { tloc (ATyp_id $1) }
  | tyvar
    { tloc (ATyp_var $1) }
  | effect_typ
    { $1 }
  | Inc
    { tloc (ATyp_inc) }
  | Dec
    { tloc (ATyp_dec) } 
  | SquareBar nexp_typ BarSquare
      { tloc (make_enum_sugar $2) }
  | SquareBar nexp_typ Colon nexp_typ BarSquare
      { tloc (make_enum_sugar_bounded $2 $4) }
  | Lparen typ Rparen
    { $2 }

vec_typ:
  | atomic_typ
      { $1 }
  | tid Lsquare nexp_typ Rsquare
      { tloc (make_vector_sugar (ATyp_aux ((ATyp_id $1), locn 1 1)) $3) }
  | tid Lsquare nexp_typ Colon nexp_typ Rsquare
      { tloc (make_vector_sugar_bounded (ATyp_aux ((ATyp_id $1), locn 1 1)) $3 $5) }
  | tyvar Lsquare nexp_typ Rsquare
      { tloc (make_vector_sugar (ATyp_aux ((ATyp_var $1), locn 1 1)) $3) }
  | tyvar Lsquare nexp_typ Colon nexp_typ Rsquare
      { tloc (make_vector_sugar_bounded (ATyp_aux ((ATyp_var $1), locn 1 1)) $3 $5) }

app_typs:
  | vec_typ
    { [$1] }
  | Num
    { [tloc (ATyp_constant $1)] }
  | Num app_typs
    { (ATyp_aux((ATyp_constant $1),locn 1 1))::$2 }
  | vec_typ app_typs
    { $1::$2 }

app_typ:
  | vec_typ
    { $1 }
  | tid Lt app_typs Gt
    { tloc (ATyp_app($1,$3)) }

star_typ_list:
  | app_typ
    { [$1] }
  | app_typ Star star_typ_list
    { $1::$3 }

star_typ:
  | star_typ_list
    { match $1 with
        | [] -> assert false
        | [t] -> t
        | ts -> tloc (ATyp_tup(ts)) }

exp_typ:
   | star_typ
     { $1 }
   | Num
     { tloc (ATyp_constant $1) }
   | TwoStarStar typ
     { tloc (ATyp_exp($2)) }

nexp_typ:
   | exp_typ
     { $1 }
   | atomic_typ Plus nexp_typ
     { tloc (ATyp_sum($1,$3)) }
   | Lparen atomic_typ Plus nexp_typ Rparen
     { tloc (ATyp_sum($2,$4)) }

typ:
  | star_typ
    { $1 }
  | star_typ MinusGt typ effect_typ
    { tloc (ATyp_fn($1,$3,$4)) }

lit:
  | True
    { lloc L_true }
  | False
    { lloc L_false }
  | Num
    { lloc (L_num $1) }
  | String
    { lloc (L_string $1) }
  | Lparen Rparen
    { lloc L_unit }
  | Bin
    { lloc (L_bin $1) }
  | Hex
    { lloc (L_hex $1) }
  | Undefined
    { lloc L_undef }


atomic_pat:
  | lit
    { ploc (P_lit $1) }
  | Under
    { ploc P_wild }
  | Lparen pat As id Rparen
    { ploc (P_as($2,$4)) }
  | Lparen typ Rparen atomic_pat
    { ploc (P_typ($2,$4)) } 
  | id
    { ploc (P_app($1,[])) }
  | Lcurly fpats Rcurly
    { ploc (P_record((fst $2, snd $2))) }
  | Lsquare comma_pats Rsquare
    { ploc (P_vector($2)) }
  | Lsquare pat Rsquare
    { ploc (P_vector([$2])) }
  | Lsquare npats Rsquare
    { ploc (P_vector_indexed($2)) }
  | Lparen comma_pats Rparen
    { ploc (P_tup($2)) }
  | SquareBarBar BarBarSquare
    { ploc (P_list([])) }
  | SquareBarBar pat BarBarSquare
    { ploc (P_list([$2])) }
  | SquareBarBar comma_pats BarBarSquare
    { ploc (P_list($2)) }
  | Lparen pat Rparen
    { $2 }

app_pat:
  | atomic_pat
    { $1 }
  | id Lparen comma_pats Rparen
    { ploc (P_app($1,$3)) }
  | id Lparen pat Rparen
    { ploc (P_app($1,[$3])) }

pat_colons:
  | atomic_pat Colon atomic_pat
    { ([$1;$3]) }
  | atomic_pat Colon pat_colons
    { ($1::$3) }

pat:
  | app_pat
    { $1 }
  | pat_colons
    { ploc (P_vector_concat($1)) }

comma_pats:
  | atomic_pat Comma atomic_pat
    { [$1;$3] }
  | atomic_pat Comma comma_pats
    { $1::$3 }

fpat:
  | id Eq pat
    { fploc (FP_Fpat($1,$3)) }

fpats:
  | fpat
    { ([$1], false) }
  | fpat Semi
    { ([$1], true) }
  | fpat Semi fpats
    { ($1::fst $3, snd $3) }

npat:
  | Num Eq pat
    { ($1,$3) }

npats:
  | npat
    { [$1] }
  | npat Comma npats
    { ($1::$3) }

atomic_exp:
  | Lcurly semi_exps Rcurly
    { eloc (E_block $2) }
  | id
    { eloc (E_id($1)) }
  | lit
    { eloc (E_lit($1)) }
  | Lparen exp Rparen
    { $2 }
  | Lparen typ Rparen atomic_exp 
    { eloc (E_cast($2,$4)) }
  | Lparen comma_exps Rparen
    { eloc (E_tuple($2)) }
  | Lcurly exp With semi_exps Rcurly
    { eloc (E_record_update($2,$4)) } 
  | Lsquare comma_exps Rsquare
    { eloc (E_vector($2)) }
  | Lsquare exp With atomic_exp Eq exp Rsquare
    { eloc (E_vector_update($2,$4,$6)) }
  | Lsquare exp With atomic_exp Colon atomic_exp Eq exp Rsquare
    { eloc (E_vector_update_subrange($2,$4,$6,$8)) }
  | SquareBarBar comma_exps BarBarSquare
    { eloc (E_list($2)) }
  | Switch exp Lcurly case_exps Rcurly
    { eloc (E_case($2,$4)) }

field_exp:
  | atomic_exp
    { $1 }
  | atomic_exp Dot id
    { eloc (E_field($1,$3)) }

vaccess_exp:
  | field_exp
    { $1 }
  | atomic_exp Lsquare exp Rsquare
    { eloc (E_vector_access($1,$3)) }
  | atomic_exp Lsquare exp DotDot exp Rsquare
    { eloc (E_vector_subrange($1,$3,$5)) }

app_exp:
  | vaccess_exp
    { $1 }
  | id Lparen Rparen
    { eloc (E_app($1, [eloc (E_lit (lloc L_unit))])) }
  | id Lparen exp Rparen
    { eloc (E_app($1,[ E_aux((E_tuple [$3]),locn 3 3)])) }
  | id Lparen comma_exps Rparen
    { eloc (E_app($1,[E_aux (E_tuple $3,locn 3 3)])) }

right_atomic_exp:
  | If_ exp Then exp Else exp
    { eloc (E_if($2,$4,$6)) }
  | If_ exp Then exp
    { eloc (E_if($2,$4, eloc (E_lit(lloc L_unit)))) }
  | Foreach id Id atomic_exp Id atomic_exp By atomic_exp exp
    { if $3 <> "from" then
       raise (Parse_error_locn ((loc ()),"Missing \"from\" in foreach loop"));
      if $5 <> "to" && $5 <> "downto" then
       raise (Parse_error_locn ((loc ()),"Missing \"to\" or \"downto\" in foreach loop"));
      let step =
        if $5 = "to"
        then $8
        else eloc (E_app_infix(eloc (E_lit(lloc (L_num 0))), idl (Id "-"), $8)) in
      eloc (E_for($2,$4,$6,step,$9)) }
  | Foreach id Id atomic_exp Id atomic_exp exp
    { if $3 <> "from" then
       raise (Parse_error_locn ((loc ()),"Missing \"from\" in foreach loop"));
      if $5 <> "to" && $5 <> "downto" then
       raise (Parse_error_locn ((loc ()),"Missing \"to\" or \"downto\" in foreach loop"));
      let step =
        if $5 = "to"
        then eloc (E_lit(lloc (L_num 1)))
        else eloc (E_lit(lloc (L_num (-1)))) in
      eloc (E_for($2,$4,$6,step,$7)) }
  | letbind In exp
    { eloc (E_let($1,$3)) }

starstar_exp:
  | app_exp
    { $1 }
  | starstar_exp StarStar app_exp
    { eloc (E_app_infix($1,Id_aux(Id($2), locn 2 2), $3)) }

starstar_right_atomic_exp:
  | right_atomic_exp
    { $1 }
  | starstar_exp StarStar right_atomic_exp
    { eloc (E_app_infix($1,Id_aux(Id($2), locn 2 2), $3)) }

star_exp:
  | starstar_exp
    { $1 }
  | star_exp Star starstar_exp
    { eloc (E_app_infix($1,Id_aux(Id($2), locn 2 2), $3)) }
  | star_exp Div starstar_exp
    { eloc (E_app_infix($1,Id_aux(Id($2), locn 2 2), $3)) }
  | star_exp Div_ starstar_exp
    { eloc (E_app_infix($1,Id_aux(Id("div"), locn 2 2), $3)) }
  | star_exp Quot starstar_exp
    { eloc (E_app_infix($1,Id_aux(Id("quot"), locn 2 2), $3)) }
  | star_exp Rem starstar_exp
    { eloc (E_app_infix($1,Id_aux(Id("rem"), locn 2 2), $3)) }
  | star_exp Mod starstar_exp
    { eloc (E_app_infix($1,Id_aux(Id("mod"), locn 2 2), $3)) }
  | star_exp StarUnderS starstar_exp
    { eloc (E_app_infix($1,Id_aux(Id($2), locn 2 2), $3)) }
  | star_exp StarUnderSi starstar_exp
    { eloc (E_app_infix($1,Id_aux(Id($2), locn 2 2), $3)) }
  | star_exp StarUnderU starstar_exp
    { eloc (E_app_infix($1,Id_aux(Id($2), locn 2 2), $3)) }
  | star_exp StarUnderUi starstar_exp
    { eloc (E_app_infix($1,Id_aux(Id($2), locn 2 2), $3)) }

star_right_atomic_exp:
  | starstar_right_atomic_exp
    { $1 }
  | star_exp Star starstar_right_atomic_exp
    { eloc (E_app_infix($1,Id_aux(Id($2), locn 2 2), $3)) }
  | star_exp Div starstar_right_atomic_exp
    { eloc (E_app_infix($1,Id_aux(Id($2), locn 2 2), $3)) }
  | star_exp Div_ starstar_right_atomic_exp
    { eloc (E_app_infix($1,Id_aux(Id("div"), locn 2 2), $3)) }
  | star_exp Quot starstar_right_atomic_exp
    { eloc (E_app_infix($1,Id_aux(Id("quot"), locn 2 2), $3)) }
  | star_exp Rem starstar_right_atomic_exp
    { eloc (E_app_infix($1,Id_aux(Id("rem"), locn 2 2), $3)) }
  | star_exp Mod starstar_right_atomic_exp
    { eloc (E_app_infix($1,Id_aux(Id("mod"), locn 2 2), $3)) }
  | star_exp StarUnderS starstar_right_atomic_exp
    { eloc (E_app_infix($1,Id_aux(Id($2), locn 2 2), $3)) }
  | star_exp StarUnderU starstar_right_atomic_exp
    { eloc (E_app_infix($1,Id_aux(Id($2), locn 2 2), $3)) }

plus_exp:
  | star_exp
    { $1 }
  | plus_exp Plus star_exp
    { eloc (E_app_infix($1,Id_aux(Id($2), locn 2 2), $3)) }
  | plus_exp Minus star_exp
    { eloc (E_app_infix($1,Id_aux(Id("-"), locn 2 2), $3)) }

plus_right_atomic_exp:
  | star_right_atomic_exp
    { $1 }
  | plus_exp Plus star_right_atomic_exp
    { eloc (E_app_infix($1,Id_aux(Id($2), locn 2 2), $3)) }
  | plus_exp Minus star_right_atomic_exp
    { eloc (E_app_infix($1,Id_aux(Id("-"), locn 2 2), $3)) }

shift_exp:
  | plus_exp
    { $1 }
  | shift_exp GtGt plus_exp
    { eloc (E_app_infix($1,Id_aux(Id($2), locn 2 2), $3)) }
  | shift_exp GtGtGt plus_exp
    { eloc (E_app_infix($1,Id_aux(Id($2), locn 2 2), $3)) }
  | shift_exp LtLt plus_exp
    { eloc (E_app_infix($1,Id_aux(Id($2), locn 2 2), $3)) }
  | shift_exp LtLtLt plus_exp
    { eloc (E_app_infix($1,Id_aux(Id($2), locn 2 2), $3)) }

shift_right_atomic_exp:
  | plus_right_atomic_exp
    { $1 }
  | shift_exp GtGt plus_right_atomic_exp
    { eloc (E_app_infix($1,Id_aux(Id($2), locn 2 2), $3)) }
  | shift_exp GtGtGt plus_right_atomic_exp
    { eloc (E_app_infix($1,Id_aux(Id($2), locn 2 2), $3)) }
  | shift_exp LtLt plus_right_atomic_exp
    { eloc (E_app_infix($1,Id_aux(Id($2), locn 2 2), $3)) }
  | shift_exp LtLtLt plus_right_atomic_exp
    { eloc (E_app_infix($1,Id_aux(Id($2), locn 2 2), $3)) }


cons_exp:
  | shift_exp
    { $1 }
  | shift_exp ColonColon cons_exp
    { eloc (E_cons($1,$3)) }
  | shift_exp Colon cons_exp
    { eloc (E_app_infix($1,Id_aux(Id(":"), locn 2 2), $3)) }

cons_right_atomic_exp:
  | shift_right_atomic_exp
    { $1 }
  | shift_exp ColonColon cons_right_atomic_exp
    { eloc (E_cons($1,$3)) }

at_exp:
  | cons_exp
    { $1 }
  | cons_exp At at_exp
    { eloc (E_app_infix($1,Id_aux(Id($2), locn 2 2), $3)) }
  | cons_exp CarrotCarrot at_exp
    { eloc (E_app_infix($1,Id_aux(Id($2), locn 2 2), $3)) }
  | cons_exp Carrot at_exp
    { eloc (E_app_infix($1,Id_aux(Id($2), locn 2 2), $3)) }
  | cons_exp TildeCarrot at_exp
    { eloc (E_app_infix($1,Id_aux(Id($2), locn 2 2), $3)) }

at_right_atomic_exp:
  | cons_right_atomic_exp
    { $1 }
  | cons_exp At at_right_atomic_exp
    { eloc (E_app_infix($1,Id_aux(Id($2), locn 2 2), $3)) }
  | cons_exp CarrotCarrot at_right_atomic_exp
    { eloc (E_app_infix($1,Id_aux(Id($2), locn 2 2), $3)) }
  | cons_exp Carrot at_right_atomic_exp
    { eloc (E_app_infix($1,Id_aux(Id($2), locn 2 2), $3)) }

eq_exp:
  | at_exp
    { $1 }
  | eq_exp Eq at_exp
    { eloc (E_app_infix($1,Id_aux(Id($2), locn 2 2), $3)) }
  | eq_exp EqEq at_exp
    { eloc (E_app_infix($1,Id_aux(Id($2), locn 2 2), $3)) }
  | eq_exp ExclEq at_exp
    { eloc (E_app_infix($1,Id_aux(Id($2), locn 2 2), $3)) }
  | eq_exp GtEq at_exp
    { eloc (E_app_infix ($1,Id_aux(Id($2), locn 2 2), $3)) }
  | eq_exp GtEqUnderS at_exp
    { eloc (E_app_infix($1,Id_aux(Id($2), locn 2 2), $3)) }
  | eq_exp GtEqUnderU at_exp
    { eloc (E_app_infix($1,Id_aux(Id($2), locn 2 2), $3)) }
  | eq_exp Gt at_exp
    { eloc (E_app_infix ($1,Id_aux(Id($2), locn 2 2), $3)) }
  | eq_exp GtUnderS at_exp
    { eloc (E_app_infix($1,Id_aux(Id($2), locn 2 2), $3)) }
  | eq_exp GtUnderU at_exp
    { eloc (E_app_infix($1,Id_aux(Id($2), locn 2 2), $3)) }
  | eq_exp LtEq at_exp
    { eloc (E_app_infix ($1,Id_aux(Id($2), locn 2 2), $3)) }
  | eq_exp LtEqUnderS at_exp
    { eloc (E_app_infix($1,Id_aux(Id($2), locn 2 2), $3)) }
  | eq_exp Lt at_exp
    { eloc (E_app_infix ($1,Id_aux(Id($2), locn 2 2), $3)) }
  | eq_exp LtUnderS at_exp
    { eloc (E_app_infix ($1,Id_aux(Id($2), locn 2 2), $3)) }
  | eq_exp LtUnderSi at_exp
    { eloc (E_app_infix ($1,Id_aux(Id($2), locn 2 2), $3)) }
  | eq_exp LtUnderU at_exp
    { eloc (E_app_infix($1,Id_aux(Id($2), locn 2 2), $3)) }
  | eq_exp ColonEq at_exp
    { eloc (E_assign($1,$3)) }

eq_right_atomic_exp:
  | at_right_atomic_exp
    { $1 }
  | eq_exp Eq at_right_atomic_exp
    { eloc (E_app_infix($1,Id_aux(Id($2), locn 2 2), $3)) }
  | eq_exp EqEq at_right_atomic_exp
    { eloc (E_app_infix($1,Id_aux(Id($2), locn 2 2), $3)) }
  | eq_exp ExclEq at_right_atomic_exp
    { eloc (E_app_infix($1,Id_aux(Id($2), locn 2 2), $3)) }
  | eq_exp GtEq at_right_atomic_exp
    { eloc (E_app_infix ($1,Id_aux(Id($2), locn 2 2), $3)) }
  | eq_exp GtEqUnderS at_right_atomic_exp
    { eloc (E_app_infix($1,Id_aux(Id($2), locn 2 2), $3)) }
  | eq_exp GtEqUnderU at_right_atomic_exp
    { eloc (E_app_infix($1,Id_aux(Id($2), locn 2 2), $3)) }
  | eq_exp Gt at_right_atomic_exp
    { eloc (E_app_infix ($1,Id_aux(Id($2), locn 2 2), $3)) }
  | eq_exp GtUnderS at_right_atomic_exp
    { eloc (E_app_infix($1,Id_aux(Id($2), locn 2 2), $3)) }
  | eq_exp GtUnderU at_right_atomic_exp
    { eloc (E_app_infix($1,Id_aux(Id($2), locn 2 2), $3)) }
  | eq_exp LtEq at_right_atomic_exp
    { eloc (E_app_infix ($1,Id_aux(Id($2), locn 2 2), $3)) }
  | eq_exp LtEqUnderS at_right_atomic_exp
    { eloc (E_app_infix($1,Id_aux(Id($2), locn 2 2), $3)) }
  | eq_exp Lt at_right_atomic_exp
    { eloc (E_app_infix ($1,Id_aux(Id($2), locn 2 2), $3)) }
  | eq_exp LtUnderS at_right_atomic_exp
    { eloc (E_app_infix ($1,Id_aux(Id($2), locn 2 2), $3)) }
  | eq_exp LtUnderSi at_right_atomic_exp
    { eloc (E_app_infix ($1,Id_aux(Id($2), locn 2 2), $3)) }
  | eq_exp LtUnderU at_right_atomic_exp
    { eloc (E_app_infix($1,Id_aux(Id($2), locn 2 2), $3)) }
  | eq_exp ColonEq at_right_atomic_exp
    { eloc (E_assign($1,$3)) }

and_exp:
  | eq_exp
    { $1 }
  | eq_exp Amp and_exp
    { eloc (E_app_infix($1,Id_aux(Id($2), locn 2 2), $3)) }
  | eq_exp AmpAmp and_exp
    { eloc (E_app_infix($1,Id_aux(Id($2), locn 2 2), $3)) }

and_right_atomic_exp:
  | eq_right_atomic_exp
    { $1 }
  | eq_exp Amp and_right_atomic_exp
    { eloc (E_app_infix($1,Id_aux(Id($2), locn 2 2), $3)) }
  | eq_exp AmpAmp and_right_atomic_exp
    { eloc (E_app_infix($1,Id_aux(Id($2), locn 2 2), $3)) }

or_exp:
  | and_exp
    { $1 }
  | and_exp Bar or_exp
    { eloc (E_app_infix($1,Id_aux(Id("|"), locn 2 2), $3)) }
  | and_exp BarBar or_exp
    { eloc (E_app_infix($1,Id_aux(Id("||"), locn 2 2), $3)) }

or_right_atomic_exp:
  | and_right_atomic_exp
    { $1 }
  | and_exp Bar or_right_atomic_exp
    { eloc (E_app_infix($1,Id_aux(Id("|"), locn 2 2), $3)) }
  | and_exp BarBar or_right_atomic_exp
    { eloc (E_app_infix($1,Id_aux(Id("||"), locn 2 2), $3)) }

exp:
  | or_exp
    { $1 }
  | or_right_atomic_exp
    { $1 }

comma_exps:
  | exp Comma exp
    { [$1;$3] }
  | exp Comma comma_exps
    { $1::$3 }

semi_exps_help:
  | exp
    { [$1] }
  | exp Semi
    { [$1] }
  | exp Semi semi_exps_help
    { $1::$3 }

semi_exps:
  |
    { [] }
  | semi_exps_help
    { $1 }

case_exp:
  | Case patsexp
    { $2 }

case_exps:
  | case_exp
    { [$1] }
  | case_exp case_exps
    { $1::$2 }

patsexp:
  | atomic_pat MinusGt exp
    { peloc (Pat_exp($1,$3)) }

letbind:
/*  | Let_ atomic_pat Eq atomic_exp
    { lbloc (LB_val_implicit($2,$4)) }*/
  | Let_ typquant atomic_typ atomic_pat Eq exp
    { lbloc (LB_val_explicit((mk_typschm $2 $3 2 3),$4,$6)) }
  /* This is ambiguous causing 4 shift/reduce and 5 reduce/reduce conflicts because the parser can't tell until the end of typ whether it was parsing a type or a pattern, and this seem to be too late. Solutions are to have a different keyword for this and the above solution besides let (while still absolutely having a keyword here) */
  | Let_ atomic_typ atomic_pat Eq exp
    { lbloc (LB_val_explicit((mk_typschm (mk_typqn ()) $2 2 2),$3,$5)) } 

funcl:
  | id atomic_pat Eq exp
    { funclloc (FCL_Funcl($1,$2,$4)) }

funcl_ands:
  | funcl
    { [$1] }
  | funcl And funcl_ands
    { $1::$3 }

/* This causes ambiguity because without a type quantifier it's unclear whether the first id is a function name or a type name for the optional types.*/
fun_def:
  | Function_ Rec typquant typ effect_typ funcl_ands
    { funloc (FD_function(mk_rec 2, mk_tannot $3 $4 3 4, mk_eannot $5 5, $6)) }
  | Function_ Rec typquant typ funcl_ands
    { funloc (FD_function(mk_rec 2, mk_tannot $3 $4 3 4, mk_eannotn (), $5)) }
  | Function_ Rec typ effect_typ funcl_ands
    { funloc (FD_function(mk_rec 2, mk_tannot (mk_typqn ()) $3 3 3, mk_eannot $4 4, $5)) }
  | Function_ Rec typ funcl_ands
    { match $3 with
      | ATyp_aux(ATyp_efid _, _) | ATyp_aux(ATyp_set _, _) ->
        funloc (FD_function(mk_rec 2,mk_tannotn (), mk_eannot $3 3, $4))
      | _ ->
        funloc (FD_function(mk_rec 2,mk_tannot (mk_typqn ()) $3 3 3, mk_eannotn (), $4)) }
/*  | Function_ Rec funcl_ands
    { funloc (FD_function(mk_rec 2, mk_tannotn (), mk_eannotn (), $3)) }
*/  | Function_ typquant atomic_typ effect_typ funcl_ands
    { funloc (FD_function(mk_recn (), mk_tannot $2 $3 2 3, mk_eannot $4 4, $5)) }
  | Function_ typquant typ funcl_ands
    { funloc (FD_function(mk_recn (), mk_tannot $2 $3 2 2, mk_eannotn (), $4)) }
  | Function_ typ funcl_ands
    { match $2 with
      | ATyp_aux(ATyp_efid _, _) | ATyp_aux(ATyp_set _, _) ->
        funloc (FD_function(mk_recn (),mk_tannotn (), mk_eannot $2 2, $3))
      | _ ->
        funloc (FD_function(mk_recn (),mk_tannot (mk_typqn ()) $2 2 2, mk_eannotn (), $3)) }
/*  | Function_ funcl_ands
    { funloc (FD_function(mk_recn (), mk_tannotn (), mk_eannotn (), $2)) }
*/

val_spec:
  | Val typquant typ id
    { vloc (VS_val_spec(mk_typschm $2 $3 2 3,$4)) }
  | Val typ id
    { vloc (VS_val_spec(mk_typschm (mk_typqn ()) $2 2 2,$3)) }
  | Val Extern typquant typ id
    { vloc (VS_extern_no_rename (mk_typschm $3 $4 3 4,$5)) }
  | Val Extern typ id
    { vloc (VS_extern_no_rename (mk_typschm (mk_typqn ()) $3 3 3, $4)) }
  | Val Extern typquant typ id Eq String
    { vloc (VS_extern_spec (mk_typschm $3 $4 3 4,$5,$7)) }
  | Val Extern typ id Eq String
    { vloc (VS_extern_spec (mk_typschm (mk_typqn ()) $3 3 3,$4, $6)) }

kinded_id:
  | tyvar
    { kiloc (KOpt_none $1) }
  | kind tyvar
    { kiloc (KOpt_kind($1,$2))}

/*kinded_ids:
  | kinded_id
    { [$1] }
  | kinded_id kinded_ids
    { $1::$2 }*/

nums:
  | Num
    { [$1] }
  | Num Comma nums
    { $1::$3 }

nexp_constraint:
  | typ Eq typ
    { NC_aux(NC_fixed($1,$3), loc () ) }
  | typ GtEq typ
    { NC_aux(NC_bounded_ge($1,$3), loc () ) }
  | typ LtEq typ
    { NC_aux(NC_bounded_le($1,$3), loc () ) }
  | id IN Lcurly nums Rcurly
    { NC_aux(NC_nat_set_bounded($1,$4), loc ()) }

id_constraint:
  | nexp_constraint
      { QI_aux((QI_const $1), loc())}
  | kinded_id
      { QI_aux((QI_id $1), loc()) }

id_constraints:
  | id_constraint
      { [$1] }
  | id_constraint Comma id_constraints
      { $1::$3 }

typquant:
  | Forall id_constraints Dot
    { typql(TypQ_tq($2)) }

name_sect:
  | Lsquare Id Eq String Rsquare
    { Name_sect_aux(Name_sect_some($4), loc ()) }

c_def_body:
  | typ id
    { [($1,$2)],false }
  | typ id Semi
    { [($1,$2)],true }
  | typ id Semi c_def_body
    { ($1,$2)::(fst $4), snd $4 }

union_body:
  | id
    { [Tu_aux( Tu_id $1, loc())],false }
  | typ id
    { [Tu_aux( Tu_ty_id ($1,$2), loc())],false }
  | id Semi
    { [Tu_aux( Tu_id $1, loc())],true }
  | typ id Semi
    { [Tu_aux( Tu_ty_id ($1,$2),loc())],true }
  | id Semi union_body
    { (Tu_aux( Tu_id $1, loc()))::(fst $3), snd $3 }
  | typ id Semi union_body
    { (Tu_aux(Tu_ty_id($1,$2),loc()))::(fst $4), snd $4 }

index_range_atomic:
  | Num
    { irloc (BF_single($1)) }
  | Num DotDot Num
    { irloc (BF_range($1,$3)) }
  | Lparen index_range Rparen
    { $2 }

enum_body:
  | id
  { [$1] }
  | id Semi
  { [$1] }
  | id Semi enum_body
  { $1::$3 }

index_range:
  | index_range_atomic
    { $1 }
  | index_range_atomic Comma index_range
    { irloc(BF_concat($1,$3)) }

r_id_def:
  | index_range Colon id
    { $1,$3 }

r_def_body:
  | r_id_def
    { [$1] }
  | r_id_def Semi
    { [$1] }
  | r_id_def Semi r_def_body
    { $1::$3 }

type_def:
  | Typedef id name_sect Eq typquant typ
    { tdloc (TD_abbrev($2,$3,mk_typschm $5 $6 5 6)) }
  | Typedef id name_sect Eq typ
    { tdloc (TD_abbrev($2,$3,mk_typschm (mk_typqn ()) $5 5 5)) }
  | Typedef id Eq typquant typ
    { tdloc (TD_abbrev($2,mk_namesectn (), mk_typschm $4 $5 4 5))}
  | Typedef id Eq typ
    { tdloc (TD_abbrev($2,mk_namesectn (),mk_typschm (mk_typqn ()) $4 4 4)) }
  /* The below adds 4 shift/reduce conflicts. Due to c_def_body and confusions in id id and parens  */
  | Typedef id name_sect Eq Const Struct typquant Lcurly c_def_body Rcurly
    { tdloc (TD_record($2,$3,$7,fst $9, snd $9)) }
  | Typedef id name_sect Eq Const Struct Lcurly c_def_body Rcurly
    { tdloc (TD_record($2,$3,(mk_typqn ()), fst $8, snd $8)) }
  | Typedef id Eq Const Struct typquant Lcurly c_def_body Rcurly
    { tdloc (TD_record($2,mk_namesectn (), $6, fst $8, snd $8)) }
  | Typedef id Eq Const Struct Lcurly c_def_body Rcurly
    { tdloc (TD_record($2, mk_namesectn (), mk_typqn (), fst $7, snd $7)) }
  | Typedef id name_sect Eq Const Union typquant Lcurly union_body Rcurly
    { tdloc (TD_variant($2,$3, $7, fst $9, snd $9)) }
  | Typedef id Eq Const Union typquant Lcurly union_body Rcurly
    { tdloc (TD_variant($2,mk_namesectn (), $6, fst $8, snd $8)) }
  | Typedef id name_sect Eq Const Union Lcurly union_body Rcurly
    { tdloc (TD_variant($2, $3, mk_typqn (), fst $8, snd $8)) }
  | Typedef id Eq Const Union Lcurly union_body Rcurly
    { tdloc (TD_variant($2, mk_namesectn (), mk_typqn (), fst $7, snd $7)) }
  | Typedef id Eq Enumerate Lcurly enum_body Rcurly
    { tdloc (TD_enum($2, mk_namesectn (), $6,false)) }
  | Typedef id name_sect Eq Enumerate Lcurly enum_body Rcurly
    { tdloc (TD_enum($2,$3,$7,false)) }
  | Typedef id Eq Register Bits Lsquare nexp_typ Colon nexp_typ Rsquare Lcurly r_def_body Rcurly
    { tdloc (TD_register($2, $7, $9, $12)) }


default_typ:
  | Default atomic_kind tyvar
    { defloc (DT_kind($2,$3)) }
  | Default typquant typ id
    { defloc (DT_typ((mk_typschm $2 $3 2 3),$4)) }
  | Default typ id
    { defloc (DT_typ((mk_typschm (mk_typqn ()) $2 2 2),$3)) }

scattered_def:
  | Function_ Rec typquant typ effect_typ id
    { (DEF_scattered_function(mk_rec 2, mk_tannot $3 $4 3 4, mk_eannot $5 5, $6)) }
  | Function_ Rec typ effect_typ id
    { (DEF_scattered_function(mk_rec 2, mk_tannot (mk_typqn ()) $3 3 3, mk_eannot $4 4, $5)) }
  | Function_ Rec typquant typ id
    { (DEF_scattered_function(mk_rec 2, mk_tannot $3 $4 3 4, mk_eannotn (), $5)) }
  | Function_ Rec typ id
    { match $3 with
      | (ATyp_aux(ATyp_efid _, _)) | (ATyp_aux(ATyp_set _, _)) ->
        (DEF_scattered_function(mk_rec 2, mk_tannotn (), mk_eannot $3 3, $4))
      | _ ->
        (DEF_scattered_function(mk_rec 2,mk_tannot (mk_typqn ()) $3 3 3, mk_eannotn (), $4)) }
  | Function_ Rec id
    { (DEF_scattered_function(mk_rec 2,mk_tannotn (), mk_eannotn (),$3)) }
  | Function_ typquant typ effect_typ id
    { (DEF_scattered_function(mk_recn (),mk_tannot $2 $3 2 3, mk_eannot $4 4, $5)) }
  | Function_ typ effect_typ id
    { (DEF_scattered_function(mk_recn (), mk_tannot (mk_typqn ()) $2 2 2, mk_eannot $3 3, $4)) }
  | Function_ typquant typ id
    { (DEF_scattered_function(mk_recn (), mk_tannot $2 $3 2 3, mk_eannotn (), $4)) }
  | Function_ typ id
    { match $2 with
      | (ATyp_aux(ATyp_efid _, _)) | (ATyp_aux(ATyp_set _, _)) ->
        (DEF_scattered_function(mk_recn (), mk_tannotn (), mk_eannot $2 2, $3))
      | _ ->
        (DEF_scattered_function(mk_recn (), mk_tannot (mk_typqn ()) $2 2 2, mk_eannotn (), $3)) }
  | Function_ id
    { (DEF_scattered_function(mk_recn (), mk_tannotn (), mk_eannotn (), $2)) }
  | Typedef id name_sect Eq Const Union typquant
    { (DEF_scattered_variant($2,$3,$7)) }
  | Typedef id Eq Const Union typquant
    { (DEF_scattered_variant($2,(mk_namesectn ()),$6)) }
  | Typedef id name_sect Eq Const Union
    { (DEF_scattered_variant($2,$3,mk_typqn ())) }
  | Typedef id Eq Const Union
    { (DEF_scattered_variant($2,mk_namesectn (),mk_typqn ())) }

def:
  | type_def
    { dloc (DEF_type($1)) }
  | fun_def
    { dloc (DEF_fundef($1)) }
  | letbind
    { dloc (DEF_val($1)) }
  | val_spec
    { dloc (DEF_spec($1)) }
  | default_typ
    { dloc (DEF_default($1)) }
  | Register atomic_typ id
    { dloc (DEF_reg_dec($2,$3)) }
  | Scattered scattered_def
    { dloc $2 }
  | Function_ Clause funcl
    { dloc (DEF_scattered_funcl($3)) }
  | Union id Member atomic_typ id
    { dloc (DEF_scattered_unioncl($2,$4,$5)) }
  | End id
    { dloc (DEF_scattered_end($2)) }

defs_help:
  | def
    { [$1] }
  | def defs_help
    { $1::$2 }

defs:
  | defs_help
    { (Defs $1) }

file:
  | defs Eof
    { $1 }

