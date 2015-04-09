//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"

let dirty = "df.png"
let clean = dirty.stringByReplacingOccurrencesOfString(
    ".png",
    withString: "",
    options: .RegularExpressionSearch)