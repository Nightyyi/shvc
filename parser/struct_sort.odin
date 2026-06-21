/*
   Copyright 2026 Shiver Contributors

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/

package parser

import "ast"
import types "stock_types"
import "core:log"

sort_struct_literal :: proc(Struct_Fields: ^[dynamic]ast.Struct_Literal_Field) {

  log.error("\n\n\n\n\nIS SORTING\n\n\n\n")
  log.error(Struct_Fields^)
	quick_sort_struct(Struct_Fields, 0, cast(i32)(len(Struct_Fields^)))
}

hash_string :: proc(in_string: string) -> i32 {
	hash: i32 = 0
	for character in in_string {
		hash = 37 * hash + cast(i32)character
	}
	return hash
}

get_score_of_struct_field :: proc(struct_field: ast.Struct_Literal_Field) -> i64 {
	if type_of(struct_field.value^) == ast.String_Literal {
		string_literal: ast.String_Literal = struct_field.value.(ast.String_Literal)
		real_type: types.Types = parse_type_from_identifier(string_literal.value)
		size_in_bytes: i64 = cast(i64)(type_to_size(real_type))
		score: i64 = size_in_bytes << 32 | cast(i64)hash_string(struct_field.name)
		return score
	} else {
		return -1
	}
}

get_score :: proc(Struct_Fields: ^[dynamic]ast.Struct_Literal_Field, index: i32) -> i64 {
	return get_score_of_struct_field(Struct_Fields^[index])
}

quick_sort_struct :: proc(
	Struct_Fields: ^[dynamic]ast.Struct_Literal_Field,
	start: i32,
	end: i32,
) {
	SF := Struct_Fields
	if (end - start - 1) < 2 {return}

	midpoint_index := (start + end) >> 1
	pivot: i32 = start
	low_index: i32 = start + 1
	high_index: i32 = end

	swap_fields(SF, midpoint_index, pivot)

	for true {
    log.errorf("%i %i\n", high_index, low_index)
		if high_index < low_index {
			swap_fields(SF, pivot, high_index)
			break
		}
		if get_score(SF, high_index) > get_score(SF, pivot) {high_index -= 1}
		if get_score(SF, low_index) < get_score(SF, pivot) {low_index += 1}
		swap_fields(SF, high_index, low_index)
	}
	quick_sort_struct(SF, start, high_index)
	quick_sort_struct(SF, low_index, end)
}

swap_fields_cmp :: proc(
	Struct_Fields: ^[dynamic]ast.Struct_Literal_Field,
	index_high: i32,
	index_low: i32,
) {
	field_high := Struct_Fields[index_high]
	field_low := Struct_Fields[index_low]

	if get_score_of_struct_field(field_low) > get_score_of_struct_field(field_high)  {
		assign_at(Struct_Fields, index_low, field_high)
		assign_at(Struct_Fields, index_high, field_low)
	}
}

swap_fields :: proc(
	Struct_Fields: ^[dynamic]ast.Struct_Literal_Field,
	index_x: i32,
	index_y: i32,
) {
	field_x := Struct_Fields[index_x]
	field_y := Struct_Fields[index_y]

	assign_at(Struct_Fields, index_x, field_y)
	assign_at(Struct_Fields, index_y, field_x)
}
