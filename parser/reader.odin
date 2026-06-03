package parser

import "core:bufio"
import "core:os"

read_all :: proc(filepath: string, allocator := context.allocator) -> ^Tokenizer {
	// open the file
	f, ferr := os.open(filepath)
	if ferr != nil {
		panic("unable to open file")
	}
	defer os.close(f)

	// make the reader
	r: bufio.Reader
	// i swear if they put more than 512 characters on singular line
	// i will crash out
	buffer: [512]byte
	bufio.reader_init_with_buf(&r, os.to_stream(f), buffer[:])
	defer bufio.reader_destroy(&r)

	tokenizer := new_tokenizer(allocator)

	// read every single line
	for {
		line, err := bufio.reader_read_string(&r, '\n', context.temp_allocator)
		if err != nil {
			// end of it so we can break
			break
		}
		// cleanup
		// line = strings.trim_right(line, "\r")

		inject_src(tokenizer, line)
	}

	return tokenizer
}
