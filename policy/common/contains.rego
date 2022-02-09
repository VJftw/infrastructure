package vjp.common

contains(haystack, needle) {
	haystack[_] = needle
}

contains_all(haystack, needles) {
	haystack_set := array_to_set(haystack)
	needles_set := array_to_set(needles)
	count(needles_set - haystack_set) == 0
}
