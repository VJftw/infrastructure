package vjp.common

test_is_empty_true {
	is_empty([])
}

test_is_empty_false {
	not is_empty(["foo"])
}
