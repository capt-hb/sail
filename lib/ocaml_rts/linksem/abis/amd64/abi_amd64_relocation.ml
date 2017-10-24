(*Generated by Lem from abis/amd64/abi_amd64_relocation.lem.*)
(** [abi_amd64_relocation] contains types and definitions relating to ABI
  * specific relocation functionality for the AMD64 ABI.
  *)

open Lem_basic_classes
open Lem_map
open Lem_maybe
open Lem_num
open Lem_string

open Error
open Missing_pervasives
open Lem_assert_extra

open Elf_types_native_uint
open Elf_file
open Elf_header
open Elf_relocation
open Elf_symbol_table
open Memory_image

open Abi_classes
open Abi_utilities

(** x86-64 relocation types. *)

let r_x86_64_none : Nat_big_num.num= (Nat_big_num.of_int 0)
let r_x86_64_64 : Nat_big_num.num= (Nat_big_num.of_int 1)
let r_x86_64_pc32 : Nat_big_num.num= (Nat_big_num.of_int 2)
let r_x86_64_got32 : Nat_big_num.num= (Nat_big_num.of_int 3)
let r_x86_64_plt32 : Nat_big_num.num= (Nat_big_num.of_int 4)
let r_x86_64_copy : Nat_big_num.num= (Nat_big_num.of_int 5)
let r_x86_64_glob_dat : Nat_big_num.num= (Nat_big_num.of_int 6)
let r_x86_64_jump_slot : Nat_big_num.num= (Nat_big_num.of_int 7)
let r_x86_64_relative : Nat_big_num.num= (Nat_big_num.of_int 8)
let r_x86_64_gotpcrel : Nat_big_num.num= (Nat_big_num.of_int 9)
let r_x86_64_32 : Nat_big_num.num= (Nat_big_num.of_int 10)
let r_x86_64_32s : Nat_big_num.num= (Nat_big_num.of_int 11)
let r_x86_64_16 : Nat_big_num.num= (Nat_big_num.of_int 12)
let r_x86_64_pc16 : Nat_big_num.num= (Nat_big_num.of_int 13)
let r_x86_64_8 : Nat_big_num.num= (Nat_big_num.of_int 14)
let r_x86_64_pc8 : Nat_big_num.num= (Nat_big_num.of_int 15)
let r_x86_64_dtpmod64 : Nat_big_num.num= (Nat_big_num.of_int 16)
let r_x86_64_dtpoff64 : Nat_big_num.num= (Nat_big_num.of_int 17)
let r_x86_64_tpoff64 : Nat_big_num.num= (Nat_big_num.of_int 18)
let r_x86_64_tlsgd : Nat_big_num.num= (Nat_big_num.of_int 19)
let r_x86_64_tlsld : Nat_big_num.num= (Nat_big_num.of_int 20)
let r_x86_64_dtpoff32 : Nat_big_num.num= (Nat_big_num.of_int 21)
let r_x86_64_gottpoff : Nat_big_num.num= (Nat_big_num.of_int 22)
let r_x86_64_tpoff32 : Nat_big_num.num= (Nat_big_num.of_int 23)
let r_x86_64_pc64 : Nat_big_num.num= (Nat_big_num.of_int 24)
let r_x86_64_gotoff64 : Nat_big_num.num= (Nat_big_num.of_int 25)
let r_x86_64_gotpc32 : Nat_big_num.num= (Nat_big_num.of_int 26)
let r_x86_64_size32 : Nat_big_num.num= (Nat_big_num.of_int 32)
let r_x86_64_size64 : Nat_big_num.num= (Nat_big_num.of_int 33)
let r_x86_64_gotpc32_tlsdesc : Nat_big_num.num= (Nat_big_num.of_int 34)
let r_x86_64_tlsdesc_call : Nat_big_num.num= (Nat_big_num.of_int 35)
let r_x86_64_tlsdesc : Nat_big_num.num= (Nat_big_num.of_int 36)
let r_x86_64_irelative : Nat_big_num.num= (Nat_big_num.of_int 37)

(** [string_of_x86_64_relocation_type m] produces a string representation of the
  * relocation type [m].
  *)
(*val string_of_amd64_relocation_type : natural -> string*)
let string_of_amd64_relocation_type rel_type1:string=  
 (if Nat_big_num.equal rel_type1 r_x86_64_none then
    "R_X86_64_NONE"
  else if Nat_big_num.equal rel_type1 r_x86_64_64 then
    "R_X86_64_64"
  else if Nat_big_num.equal rel_type1 r_x86_64_pc32 then
    "R_X86_64_PC32"
  else if Nat_big_num.equal rel_type1 r_x86_64_got32 then
    "R_X86_64_GOT32"
  else if Nat_big_num.equal rel_type1 r_x86_64_plt32 then
    "R_X86_64_PLT32"
  else if Nat_big_num.equal rel_type1 r_x86_64_copy then
    "R_X86_64_COPY"
  else if Nat_big_num.equal rel_type1 r_x86_64_glob_dat then
    "R_X86_64_GLOB_DAT"
  else if Nat_big_num.equal rel_type1 r_x86_64_jump_slot then
    "R_X86_64_JUMP_SLOT"
  else if Nat_big_num.equal rel_type1 r_x86_64_relative then
    "R_X86_64_RELATIVE"
  else if Nat_big_num.equal rel_type1 r_x86_64_gotpcrel then
    "R_X86_64_GOTPCREL"
  else if Nat_big_num.equal rel_type1 r_x86_64_32 then
    "R_X86_64_32"
  else if Nat_big_num.equal rel_type1 r_x86_64_32s then
    "R_X86_64_32S"
  else if Nat_big_num.equal rel_type1 r_x86_64_16 then
    "R_X86_64_16"
  else if Nat_big_num.equal rel_type1 r_x86_64_pc16 then
    "R_X86_64_PC16"
  else if Nat_big_num.equal rel_type1 r_x86_64_8 then
    "R_X86_64_8"
  else if Nat_big_num.equal rel_type1 r_x86_64_pc8 then
    "R_X86_64_PC8"
  else if Nat_big_num.equal rel_type1 r_x86_64_dtpmod64 then
    "R_X86_64_DTPMOD64"
  else if Nat_big_num.equal rel_type1 r_x86_64_dtpoff64 then
    "R_X86_64_DTPOFF64"
  else if Nat_big_num.equal rel_type1 r_x86_64_tpoff64 then
    "R_X86_64_TPOFF64"
  else if Nat_big_num.equal rel_type1 r_x86_64_tlsgd then
    "R_X86_64_TLSGD"
  else if Nat_big_num.equal rel_type1 r_x86_64_tlsld then
    "R_X86_64_TLSLD"
  else if Nat_big_num.equal rel_type1 r_x86_64_dtpoff32 then
    "R_X86_64_DTPOFF32"
  else if Nat_big_num.equal rel_type1 r_x86_64_gottpoff then
    "R_X86_64_GOTTPOFF"
  else if Nat_big_num.equal rel_type1 r_x86_64_tpoff32 then
    "R_X86_64_TPOFF32"
  else if Nat_big_num.equal rel_type1 r_x86_64_pc64 then
    "R_X86_64_PC64"
  else if Nat_big_num.equal rel_type1 r_x86_64_gotoff64 then
    "R_X86_64_GOTOFF64"
  else if Nat_big_num.equal rel_type1 r_x86_64_gotpc32 then
    "R_X86_64_GOTPC32"
  else if Nat_big_num.equal rel_type1 r_x86_64_size32 then
    "R_X86_64_SIZE32"
  else if Nat_big_num.equal rel_type1 r_x86_64_size64 then
    "R_X86_64_SIZE64"
  else if Nat_big_num.equal rel_type1 r_x86_64_gotpc32_tlsdesc then
    "R_X86_64_GOTPC32_TLSDESC"
  else if Nat_big_num.equal rel_type1 r_x86_64_tlsdesc_call then
    "R_X86_64_TLSDESC_CALL"
  else if Nat_big_num.equal rel_type1 r_x86_64_tlsdesc then
    "R_X86_64_TLSDESC"
  else if Nat_big_num.equal rel_type1 r_x86_64_irelative then
    "R_X86_64_IRELATIVE"
  else
    "Invalid X86_64 relocation")

(* How do we find the GOT? *)
(* We really want to find the GOT without knowing how it's labelled, because 
 * in this file 'abifeature is abstract. This is a real problem. So for now, 
 * we use the HACK of looking for a section called ".got".
 * Even then, we can't understand the content of the GOT without reading the tag.
 *
 * So we can
 * 
 * - accept an argument of type abi 'abifeature and call a function on it to get the GOT
       (but then type abi becomes a recursive record type);
 * - extend the AbiFeatureTagEquiv class into a generic class capturing ABIs;
       then we risk breaking various things in Isabelle because Lem's type classes don't work there;
 * - move the amd64_reloc function to abis.lem and define it only for any_abi_feature.
 *)

(** [abi_amd64_apply_relocation rel val_map ef]
  * calculates the effect of a relocation of type [rel] using relevant addresses,
  * offsets and fields represented by [b_val], [g_val], [got_val], [l_val], [p_val],
  * [s_val] and [z_val], stored in [val_map] with "B", "G", and so on as string
  * keys, which are:
  *
  *    - B  : Base address at which a shared-object has been loaded into memory
  *           during execution.
  *    - G  : Represents the offset into the GOT at which the relocation's entry
  *           will reside during execution.
  *    - GOT: Address of the GOT.
  *    - L  : Represents the address or offset of the PLT entry for a symbol.
  *    - P  : Represents the address or offset of the storage unit being
  *           relocated.
  *    - S  : Represents the value of the symbol whose index resides in the
  *           relocation entry.
  *    - Z  : Represents the size of the symbol whose index resides in the
  *           relocation entry.
  *
  * More details of the above can be found in the AMD64 ABI document's chapter
  * on relocations.
  *
  * The [abi_amd64_apply_relocation] function returns a relocation frame, either
  * indicating that the relocation is a copy relocation, or that some calculation
  * must be carried out at a certain location.  See the comment above the
  * [relocation_frame] type in [Abi_utilities.lem] for more details.
  *)
(*val abi_amd64_apply_relocation : elf64_relocation_a -> val_map string integer -> elf64_file
  -> error (relocation_frame elf64_addr integer)*)
let abi_amd64_apply_relocation rel val_map1 ef:(((Uint64.uint64),(Nat_big_num.num))relocation_frame)error=  
 (if is_elf64_relocatable_file ef.elf64_file_header then
    let rel_type1 = (get_elf64_relocation_a_type rel) in
    let a_val    = (Nat_big_num.of_int64 rel.elf64_ra_addend) in
      (** No width, No calculation *)
      if Nat_big_num.equal rel_type1 r_x86_64_none then
        return (NoCopy ((Pmap.empty compare)))
      (** Width: 64 Calculation: S + A *)
      else if Nat_big_num.equal rel_type1 r_x86_64_64 then
        lookupM (instance_Map_MapKeyType_var_dict instance_Basic_classes_SetType_var_dict) "S" val_map1 >>= (fun s_val ->
      	let result = (Lift ( Nat_big_num.add s_val a_val)) in
      	let addr   = (rel.elf64_ra_offset) in
      		return (NoCopy (Pmap.add addr (result, I64, CannotFail) (Pmap.empty compare))))
      (** Width: 32 Calculation: S + A - P *)
      else if Nat_big_num.equal rel_type1 r_x86_64_pc32 then
        lookupM (instance_Map_MapKeyType_var_dict instance_Basic_classes_SetType_var_dict) "S" val_map1 >>= (fun s_val ->
        lookupM (instance_Map_MapKeyType_var_dict instance_Basic_classes_SetType_var_dict) "P" val_map1 >>= (fun p_val ->
      	let result = (Lift ( Nat_big_num.sub( Nat_big_num.add s_val a_val) p_val)) in
      	let addr   = (rel.elf64_ra_offset) in
      		return (NoCopy (Pmap.add addr (result, I32, CanFail) (Pmap.empty compare)))))
      (** Width: 32 Calculation: G + A *)
  		else if Nat_big_num.equal rel_type1 r_x86_64_got32 then
  		  lookupM (instance_Map_MapKeyType_var_dict instance_Basic_classes_SetType_var_dict) "G" val_map1 >>= (fun g_val ->
      	let result = (Lift ( Nat_big_num.add g_val a_val)) in
      	let addr   = (rel.elf64_ra_offset) in
      		return (NoCopy (Pmap.add addr (result, I32, CanFail) (Pmap.empty compare))))
      (** Width: 32 Calculation: L + A - P *)
  		else if Nat_big_num.equal rel_type1 r_x86_64_plt32 then
  		  lookupM (instance_Map_MapKeyType_var_dict instance_Basic_classes_SetType_var_dict) "L" val_map1 >>= (fun l_val ->
  		  lookupM (instance_Map_MapKeyType_var_dict instance_Basic_classes_SetType_var_dict) "P" val_map1 >>= (fun p_val ->
  		  let result = (Lift ( Nat_big_num.sub( Nat_big_num.add l_val a_val) p_val)) in
      	let addr   = (rel.elf64_ra_offset) in
      		return (NoCopy (Pmap.add addr (result, I32, CanFail) (Pmap.empty compare)))))
    	(** No width, No calculation *)
		  else if Nat_big_num.equal rel_type1 r_x86_64_copy then
		    return Copy
		  (** Width: 64 Calculation: S *)
		  else if Nat_big_num.equal rel_type1 r_x86_64_glob_dat then
        lookupM (instance_Map_MapKeyType_var_dict instance_Basic_classes_SetType_var_dict) "S" val_map1 >>= (fun s_val ->
      	let result = (Lift s_val) in
      	let addr   = (rel.elf64_ra_offset) in
      		return (NoCopy (Pmap.add addr (result, I64, CannotFail) (Pmap.empty compare))))
		  (** Width: 64 Calculation: S *)
		  else if Nat_big_num.equal rel_type1 r_x86_64_jump_slot then
        lookupM (instance_Map_MapKeyType_var_dict instance_Basic_classes_SetType_var_dict) "S" val_map1 >>= (fun s_val ->
      	let result = (Lift s_val) in
      	let addr   = (rel.elf64_ra_offset) in
      		return (NoCopy (Pmap.add addr (result, I64, CannotFail) (Pmap.empty compare))))
		  (** Width: 64 Calculation: B + A *)
		  else if Nat_big_num.equal rel_type1 r_x86_64_relative then
        lookupM (instance_Map_MapKeyType_var_dict instance_Basic_classes_SetType_var_dict) "B" val_map1 >>= (fun b_val ->
      	let result = (Lift ( Nat_big_num.add b_val a_val)) in
      	let addr   = (rel.elf64_ra_offset) in
      		return (NoCopy (Pmap.add addr (result, I64, CannotFail) (Pmap.empty compare))))
		  (** Width: 32 Calculation: G + GOT + A - P *)
		  else if Nat_big_num.equal rel_type1 r_x86_64_gotpcrel then
        lookupM (instance_Map_MapKeyType_var_dict instance_Basic_classes_SetType_var_dict) "G" val_map1 >>= (fun g_val ->
        lookupM (instance_Map_MapKeyType_var_dict instance_Basic_classes_SetType_var_dict) "GOT" val_map1 >>= (fun got_val ->
        lookupM (instance_Map_MapKeyType_var_dict instance_Basic_classes_SetType_var_dict) "P" val_map1 >>= (fun p_val ->
      	let result = (Lift ( Nat_big_num.sub( Nat_big_num.add (Nat_big_num.add g_val got_val) a_val) p_val)) in
      	let addr   = (rel.elf64_ra_offset) in
      		return (NoCopy (Pmap.add addr (result, I32, CanFail) (Pmap.empty compare))))))
		  (** Width: 32 Calculation: S + A *)
		  else if Nat_big_num.equal rel_type1 r_x86_64_32 then
        lookupM (instance_Map_MapKeyType_var_dict instance_Basic_classes_SetType_var_dict) "S" val_map1 >>= (fun s_val ->
      	let result = (Lift ( Nat_big_num.add s_val a_val)) in
      	let addr   = (rel.elf64_ra_offset) in
      		return (NoCopy (Pmap.add addr (result, I32, CanFail) (Pmap.empty compare))))
		  (** Width: 32 Calculation: S + A *)
		  else if Nat_big_num.equal rel_type1 r_x86_64_32s then
        lookupM (instance_Map_MapKeyType_var_dict instance_Basic_classes_SetType_var_dict) "S" val_map1 >>= (fun s_val ->
      	let result = (Lift ( Nat_big_num.add s_val a_val)) in
      	let addr   = (rel.elf64_ra_offset) in
      		return (NoCopy (Pmap.add addr (result, I32, CanFail) (Pmap.empty compare))))
		  (** Width: 16 Calculation: S + A *)
		  else if Nat_big_num.equal rel_type1 r_x86_64_16 then
        lookupM (instance_Map_MapKeyType_var_dict instance_Basic_classes_SetType_var_dict) "S" val_map1 >>= (fun s_val ->
      	let result = (Lift ( Nat_big_num.add s_val a_val)) in
      	let addr   = (rel.elf64_ra_offset) in
      		return (NoCopy (Pmap.add addr (result, I16, CanFail) (Pmap.empty compare))))
		  (** Width: 16 Calculation: S + A - P *)
		  else if Nat_big_num.equal rel_type1 r_x86_64_pc16 then
        lookupM (instance_Map_MapKeyType_var_dict instance_Basic_classes_SetType_var_dict) "S" val_map1 >>= (fun s_val ->
        lookupM (instance_Map_MapKeyType_var_dict instance_Basic_classes_SetType_var_dict) "P" val_map1 >>= (fun p_val ->
      	let result = (Lift ( Nat_big_num.sub( Nat_big_num.add s_val a_val) p_val)) in
      	let addr   = (rel.elf64_ra_offset) in
      		return (NoCopy (Pmap.add addr (result, I16, CanFail) (Pmap.empty compare)))))
		  (** Width: 8 Calculation: S + A *)
		  else if Nat_big_num.equal rel_type1 r_x86_64_8 then
        lookupM (instance_Map_MapKeyType_var_dict instance_Basic_classes_SetType_var_dict) "S" val_map1 >>= (fun s_val ->
      	let result = (Lift ( Nat_big_num.add s_val a_val)) in
      	let addr   = (rel.elf64_ra_offset) in
      		return (NoCopy (Pmap.add addr (result, I8, CanFail) (Pmap.empty compare))))
      (** Width 8: Calculation: S + A - P *)
		  else if Nat_big_num.equal rel_type1 r_x86_64_pc8 then
        lookupM (instance_Map_MapKeyType_var_dict instance_Basic_classes_SetType_var_dict) "S" val_map1 >>= (fun s_val ->
        lookupM (instance_Map_MapKeyType_var_dict instance_Basic_classes_SetType_var_dict) "P" val_map1 >>= (fun p_val ->
      	let result = (Lift ( Nat_big_num.sub( Nat_big_num.add s_val a_val) p_val)) in
      	let addr   = (rel.elf64_ra_offset) in
      		return (NoCopy (Pmap.add addr (result, I8, CanFail) (Pmap.empty compare)))))
      (** Width: 64 *)
		  else if Nat_big_num.equal rel_type1 r_x86_64_dtpmod64 then
		    failwith "abi_amd64_apply_relocation: r_x86_64_dtpmod64 not implemented"
      (** Width: 64 *)
		  else if Nat_big_num.equal rel_type1 r_x86_64_dtpoff64 then
		    failwith "abi_amd64_apply_relocation: r_x86_64_dtpoff64 not implemented"
      (** Width: 64 *)
		  else if Nat_big_num.equal rel_type1 r_x86_64_tpoff64 then
		    failwith "abi_amd64_apply_relocation: r_x86_64_tpoff64 not implemented"
      (** Width: 32 *)
		  else if Nat_big_num.equal rel_type1 r_x86_64_tlsgd then
		    failwith "abi_amd64_apply_relocation: r_x86_64_tlsgd not implemented"
      (** Width: 32 *)
		  else if Nat_big_num.equal rel_type1 r_x86_64_tlsld then
		    failwith "abi_amd64_apply_relocation: r_x86_64_tlsld not implemented"
      (** Width: 32 *)
		  else if Nat_big_num.equal rel_type1 r_x86_64_dtpoff32 then
		    failwith "abi_amd64_apply_relocation: r_x86_64_dtpoff32 not implemented"
      (** Width: 32 *)
		  else if Nat_big_num.equal rel_type1 r_x86_64_gottpoff then
		    failwith "abi_amd64_apply_relocation: r_x86_64_gottpoff not implemented"
      (** Width: 32 *)
		  else if Nat_big_num.equal rel_type1 r_x86_64_tpoff32 then
		    failwith "abi_amd64_apply_relocation: r_x86_64_tpoff32 not implemented"
		  (** Width: 64 Calculation: S + A - P *)
		  else if Nat_big_num.equal rel_type1 r_x86_64_pc64 then
        lookupM (instance_Map_MapKeyType_var_dict instance_Basic_classes_SetType_var_dict) "S" val_map1 >>= (fun s_val ->
        lookupM (instance_Map_MapKeyType_var_dict instance_Basic_classes_SetType_var_dict) "P" val_map1 >>= (fun p_val ->
      	let result = (Lift ( Nat_big_num.sub( Nat_big_num.add s_val a_val) p_val)) in
      	let addr   = (rel.elf64_ra_offset) in
      		return (NoCopy (Pmap.add addr (result, I64, CannotFail) (Pmap.empty compare)))))
		  (** Width: 64 Calculation: S + A - GOT *)
		  else if Nat_big_num.equal rel_type1 r_x86_64_gotoff64 then
        lookupM (instance_Map_MapKeyType_var_dict instance_Basic_classes_SetType_var_dict) "S" val_map1 >>= (fun s_val ->
        lookupM (instance_Map_MapKeyType_var_dict instance_Basic_classes_SetType_var_dict) "GOT" val_map1 >>= (fun got_val ->
      	let result = (Lift ( Nat_big_num.sub( Nat_big_num.add s_val a_val) got_val)) in
      	let addr   = (rel.elf64_ra_offset) in
      		return (NoCopy (Pmap.add addr (result, I64, CannotFail) (Pmap.empty compare)))))
		  (** Width: 32 Calculation: GOT + A - P *)
		  else if Nat_big_num.equal rel_type1 r_x86_64_gotpc32 then
        lookupM (instance_Map_MapKeyType_var_dict instance_Basic_classes_SetType_var_dict) "GOT" val_map1 >>= (fun got_val ->
        lookupM (instance_Map_MapKeyType_var_dict instance_Basic_classes_SetType_var_dict) "P" val_map1 >>= (fun p_val ->
      	let result = (Lift ( Nat_big_num.sub( Nat_big_num.add got_val a_val) p_val)) in
      	let addr   = (rel.elf64_ra_offset) in
      		return (NoCopy (Pmap.add addr (result, I32, CanFail) (Pmap.empty compare)))))
		  (** Width: 32 Calculation: Z + A *)
		  else if Nat_big_num.equal rel_type1 r_x86_64_size32 then
        lookupM (instance_Map_MapKeyType_var_dict instance_Basic_classes_SetType_var_dict) "Z" val_map1 >>= (fun z_val ->
      	let result = (Lift ( Nat_big_num.add z_val a_val)) in
      	let addr   = (rel.elf64_ra_offset) in
      		return (NoCopy (Pmap.add addr (result, I32, CanFail) (Pmap.empty compare))))
		  (** Width: 64 Calculation: Z + A *)
		  else if Nat_big_num.equal rel_type1 r_x86_64_size64 then
        lookupM (instance_Map_MapKeyType_var_dict instance_Basic_classes_SetType_var_dict) "Z" val_map1 >>= (fun z_val ->
      	let result = (Lift ( Nat_big_num.add z_val a_val)) in
      	let addr   = (rel.elf64_ra_offset) in
      		return (NoCopy (Pmap.add addr (result, I64, CannotFail) (Pmap.empty compare))))
      (** Width: 32 *)
		  else if Nat_big_num.equal rel_type1 r_x86_64_gotpc32_tlsdesc then
		    failwith "abi_amd64_apply_relocation: r_x86_64_gotpc32_tlsdesc not implemented"
      (** No width *)
		  else if Nat_big_num.equal rel_type1 r_x86_64_tlsdesc_call then
		    failwith "abi_amd64_apply_relocation: r_x86_64_tlsdesc_call not implemented"
		  (** Width: 64X2 *)
		  else if Nat_big_num.equal rel_type1 r_x86_64_tlsdesc then
		    failwith "abi_amd64_apply_relocation: r_x86_64_tlsdesc not implemented"
		  (** Calculation: indirect(B + A) *)
		  else if Nat_big_num.equal rel_type1 r_x86_64_irelative then
        lookupM (instance_Map_MapKeyType_var_dict instance_Basic_classes_SetType_var_dict) "B" val_map1 >>= (fun b_val ->
		    let result = (Apply(Indirect, Lift( Nat_big_num.add b_val a_val))) in
		    let addr   = (rel.elf64_ra_offset) in
		      return (NoCopy (Pmap.add addr (result, I64, CannotFail) (Pmap.empty compare))))
		  else
		  	failwith "abi_amd64_apply_relocation: invalid relocation type"
  else
  	failwith "abi_amd64_apply_relocation: not a relocatable file")