package stock_types

// same as void in c
Unit :: struct {}

Integer :: struct {}
Integer8 :: struct {}
Integer32 :: struct {}
Integer64 :: struct {}

String :: struct {}

Pointer :: struct {
	elem: ^Types,
}

Types :: union {
	Unit,
	Integer,
	Integer8,
	Integer32,
	Integer64,
	String,
	Pointer,
}
