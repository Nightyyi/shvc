package stock_types

Integer :: struct {}
Integer8 :: struct {}
Integer32 :: struct {}
Integer64 :: struct {}

String :: struct {}

Types :: union {
	Integer,
	Integer8,
	Integer32,
	Integer64,
	String,
}
