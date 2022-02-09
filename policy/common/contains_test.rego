package vjp.common

test_contains_true {
	contains(["foo"], "foo")
}

test_contains_false {
	not contains(["foo"], "bar")
}

test_contains_all_true {
	contains_all(["foo", "bar"], ["foo"])
}

test_contains_all_true {
	contains_all(["foo"], ["foo"])
}

test_contains_all_false {
	not contains_all([], ["foo"])
}

test_contains_all_false {
	not contains_all(["foo"], ["bar"])
}
