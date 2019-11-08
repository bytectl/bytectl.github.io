---
author: "wuxingzhong"
title: "go语法"
date: 2019-10-11T19:03:35+08:00
draft: false
tags: ["go"]
categories:  ["go"]
image: ""
banner: ""
comments: true     # set false to hide Disqus comments
share: true        # set false to share buttons
menu: ""           # set "main" to add this content to the main menu
---

```go
/*
* @Author: wuxingzhong
* @Date:   2017-05-16 09:18:45
* @Email:  330332812@qq.com
* @copyright:          sunniwell
* @Last Modified by:   wuxingzhong
* @Last Modified time: 2017-06-08 16:18:08
 */

package main

import (
	"fmt"
)

func run() {
	var name = "213"
	fmt.Print("name = " + name)
}

// 匿名变量, 多返回值
func GetName() (firstName, lastName, nickName string) {
	return "May", "Chan", "Chibi Maruko"
}

//  常量
func cosnt_value() {

	//  // 字面常量
	//  // 如：
	//  -12
	//  // 浮点类型的常量
	//  3.14159265358979323846
	//  // 复数类型的常量
	//  3.2 + 12i
	//  // 布尔类型的常量
	//  true
	//  // 字符串常量
	//  "foo"

	// 常量定义
	// 通过const关键字：
	const Pi float64 = 3.14159265358979323846
	const zero = 0.0 // 无类型浮点常量
	const (
		size int64 = 1024
		eof        = -1 // 无类型整型常量
	)
	const u, v float32 = 0, 3 // u = 0.0, v = 3.0，常量的多重赋值
	const a, b, c = 3, 4, "foo"
	// a = 3, b = 4, c = "foo", 无类型整型和字符串常量

	// 预定义常量
	// Go语言预定义了这些常量：true、false和iota。
	// ota比较特殊，可以被认为是一个可被编译器修改的常量，在每一个const关键字出现时被
	// 重置为0，然后在下一个const出现之前，每出现一次iota，其所代表的数字会自动增1。
	// 从以下的例子可以基本理解iota的用法：
	const (
		//iota被重设为0
		c10 = iota // c0 == 0
		c11 = iota // c1 == 1
		c12 = iota // c2 == 2

	)

	const (
		a1 = 1 << iota
		// a == 1 (iota在每个const开头被重设为0)
		b1 = 1 << iota // b == 2
		c1 = 1 << iota // c == 4
	)

	// 枚举
	const (
		Sunday = iota
		Monday
		Tuesday
		Wednesday
		Thursday
		Friday
		Saturday
		numberOfDays // 这个常量没有导出
	)
	//上例子中numberOfDays为包内私有，其他符号则可被其他包访问。
}

// 类型
func type_value() {

	// Go语言内置以下这些基础类型：
	//     布尔类型：bool。
	//     整型：int8、byte、int16、int、uint、uintptr等。
	//     浮点类型：float32、float64。
	//     复数类型：complex64、complex128。
	// 	     字符串：string。
	// 	   字符类型：rune。
	// 	   错误类型：error。
	// 此外，Go语言也支持以下这些复合类型：
	// 	   指针（pointer）
	// 	   数组（array）
	// 	   切片（slice）
	// 	   字典（map）
	// 	   通道（chan）
	// 	   结构体（struct）
	// 	   接口（interface）

	// 布尔类型
	var v1 bool
	v1 = true
	v2 := (1 == 2) // v2也会被推导为bool类型布尔类型不能接受其他类型的赋值，不支持自动或强制的类型转换。
	fmt.Println("Result:", v1)

	// 位运算
	// 取反
	// ^x   c语言中为 ~x
	// ^2     // 结果为3

	arrat := "wxzwan"
	// 遍历
	// 遍历过程可以简化为如下的写法：
	for i, v := range array {
		fmt.Println("Array element[", i, "]=", v)
	}
	// range具有两个返回值，第一个返回值是元素的数组下标，第二个返回值是元素的值。
}


// 数组切片
func array_slice() {
	// 数组的特点：数组的长度在定义之后无法再次修改；数组是值类型，
	// 每次传递都将产生一份副本。显然这种数据结构无法完全满足开发者的真实需求。

	// 初看起来，数组切片就像一个指向数组的指针，实际上它拥有自己的数据结构，而不仅仅是
	// 个指针。数组切片的数据结构可以抽象为以下3个变量：
  // 一个指向原生数组的指针；
  // 数组切片中的元素个数；
	// 数组切片已分配的存储空间

	// 创建数组切片

	//基于数组
	// 先定义一个数组
	var myArray [10] int = [10] int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}

	// 基于数组创建一个数组切片
	var mySlice [] int = myArray[:5]

	// mySlice = myArray[:]
	// mySlice = myArray[5:]

	fmt.Println("Elements of myArray: ")
	for _, v := range myArray {
		fmt.Print(v, " ")
	}

	fmt.Println("\nElements of mySlice: ")
	for _, v := range mySlice {
		fmt.Print(v, " ")
	}
	// 直接创建
	// 创建一个初始元素个数为5的数组切片，元素初始值为0：
	mySlice1 := make([]int, 5)
	// 创建一个初始元素个数为5的数组切片，元素初始值为0，并预留10个元素的存储空间：
	mySlice2 := make([]int, 5, 10)
	// 直接创建并初始化包含5个元素的数组切片：
	mySlice3 := []int{1, 2, 3, 4, 5}

	// 事实上还会有一个匿名数组被创建出来，只是不需要我们来操心而已

	// 动态增减元素
	// 可动态增减元素是数组切片比数组更为强大的功能

	// cap()函数返回的是数组切片分配的空间大小
	// len()函数返回的是数组切片中当前所存储的元素个数
	// 切片增加元素, 生成新的切片
	mySlice = append(mySlice, 1, 2, 3)
	mySlice2 := [] int{8, 9, 10}
	// 给mySlice后面添加另一个数组切片
	mySlice = append(mySlice, mySlice2...)
	// 第二个参数mySlice2后面加了三个点，即一个省略号，如果没有这个省
	// 略号的话，会有编译错误，因为按append()的语义，从第二个参数起的所有参数都是待附加的元素。因为mySlice中的元素类型为int，
	// 所以直接传递mySlice2是行不通的。加上省略号相当于把mySlice2包含的所有元素打散后传入。

	// 基于数组切片创建数组切片
	oldSlice := [] int{1, 2, 3, 4, 5}
	newSlice := oldSlice[:3]


	// 内容复制
	// 数组切片支持Go语言的另一个内置函数copy()，用于将内容从一个数组切片复制到另一个
	// 数组切片。如果加入的两个数组切片不一样大，就会按其中较小的那个数组切片的元素个数进行
	// 复制。下面的示例展示了copy()函数的行为：
	slice1 := [] int{1, 2, 3, 4, 5}
	slice2 := [] int{5, 4, 3}
	copy(slice2, slice1)  // 只会复制slice1的前3个元素到slice2中
	copy(slice1, slice2)  // 只会复制slice2的3个元素到slice1的前3个位置

}

// PersonInfo是一个包含个人详细信息的类型
type PersonInfo struct {
	ID string
	Name string
	Address string
}

func map_value() {
	// 声明
	var personDB map[string] PersonInfo
	// 创建
	personDB = make(map[string] PersonInfo)
	// 往这个map里插入几条数据
	personDB["12345"] = PersonInfo{"12345", "Tom", "Room 203,..."}
	personDB["1"] = PersonInfo{"1", "Jack", "Room 101,..."}
	// 从这个map查找键为"1234"的信息
	person, ok := personDB["1234"]
	// ok是一个返回的bool型，返回true表示找到了对应的数据
	if ok {
		fmt.Println("Found person", person.Name, "with ID 1234.")
	} else {
		fmt.Println("Did not find person with ID 1234.")
	}

	// 元素删除
	delete(personDB, "1234")

	//元素查找
	value, ok := myMap["1234"]
	if ok { // 找到了
		// 处理找到的value
	}

}
// 流程控制
func flow_control() {
	// 条件
	a := 3
	if a < 5 {
		return 0
	} else {
		return 1
	}

	// 选择语句
	switch i {
	case 0:
		fmt.Printf("0")
	case 1:
		fmt.Printf("1")
	case 2:
		fallthrough
	case 3:
		fmt.Printf("3")
	case 4, 5, 6:
		fmt.Printf("4, 5, 6")
	default:
		fmt.Printf("Default")
	}

	switch {
	case 0 <= Num && Num <= 3:
		fmt.Printf("0-3")
	case 4 <= Num && Num <= 6:
		fmt.Printf("4-6")
	case 7 <= Num && Num <= 9:
		fmt.Printf("7-9")
	}

	// 注意:与C语言等规则相反，Go语言不需要用break来明确退出一个case；
  //只有在case中明确添加fallthrough关键字，才会继续执行紧跟的下一个case；

	// 循环语句
	sum := 0
	for i := 0; i < 10; i++ {
		sum += i
	}

	// for(;;)接简化为如下的写法：
	sum := 0
	for {
		sum++
		if sum > 100 {
			break
		}
	}

	// 在条件表达式中也支持多重赋值，如下所示：
	a := [] int{1, 2, 3, 4, 5, 6}
	for i, j := 0, len(a) – 1; i < j; i, j = i + 1, j – 1 {
		a[i], a[j] = a[j], a[i]
	}

	// Go语言的for循环同样支持continue和break来控制循环，但是它提供了一个更高级的
	// break，可以选择中断哪一个循环，如下例：
	for j := 0; j < 5; j++ {
		for i := 0; i < 10; i++ {
			if i > 5 {
				break JLoop
			}
			fmt.Println(i)
		}
	}
	JLoop:
	// .....
}

// 函数
// 注意 规则：小写字母开头的函数只在本包内可见，大写字母开头的函数才能被其他包使用。
// 这个规则也适用于类型和变量的可见性。


// 不定参数
// 不定参数是指函数传入的参数个数为不定数量。为了做到这点，首先需要将函数定义为接受不定参数类型：

func myfunc(args ... int) {
	for _, arg := range args {
		fmt.Println(arg)
	}
}

// 任意类型不定参数
func myPrintf(format string, args ... interface{}) {
	for _, arg := range args {
		switch arg. (type) {
		case int:
			fmt.Println(arg, "is an int value.")
		case string:
			fmt.Println(arg, "is a string value.")
		case int64:
			fmt.Println(arg, "is an int64 value.")
		default:
			fmt.Println(arg, "is an unknown type.")
		}
	}
}

// 匿名函数
func annay_name_func() {

	f := func(x, y int) int {
	return x + y
	}
	f( 1, 2)
}

// 闭包
// Go的匿名函数是一个闭包，下面我们先来了解一下闭包的概念、价值和应用场景。
// 基本概念
// 闭包是可以包含自由（未绑定到特定对象）变量的代码块，这些变量不在这个代码块内或者
// 任何全局上下文中定义，而是在定义代码块的环境中定义。要执行的代码块（由于自由变量包含
// 在代码块中，所以这些自由变量以及它们引用的对象没有被释放）为自由变量提供绑定的计算环
// 境（作用域）。
//
// 闭包的价值
// 闭包的价值在于可以作为函数对象或者匿名函数，对于类型系统而言，这意味着不仅要表示
// 数据还要表示代码。支持闭包的多数语言都将函数作为第一级对象，就是说这些函数可以存储到
// 变量中作为参数传递给其他函数，最重要的是能够被函数动态创建和返回。
// Go语言中的闭包
// Go语言中的闭包同样也会引用到函数外的变量。闭包的实现确保只要闭包还被使用，那么
// 被闭包引用的变量会一直存在

func closure() {
	var j int = 5
	a := func()(

		func()) {
		var i int = 10
		return func() {
			fmt.Printf("i, j: %d, %d\n", i, j)
		}
	}()

	a()
	j *= 2
	a()
}

func main() {

	// 变量声明
	// 关键字var，而类型信息放在变量名之后，示例如下：
	var v1 int
	var v2 string
	var v3 [10]int

	// 数组
	//
	var v4 []int
	// 数组切片

	var v5 struct {
		f int
	}

	var v6 *int
	// 指针

	var v7 map[string]int
	// map，key为string类型，value为int类型

	var v8 func(a int) int

	//	 var的另一种用法,
	var (
		v11 int

		v12 string
	)

	// var v1 int = 10 // 正确的使用方式1
	// var v2 = 10
	// // 正确的使用方式2，编译器可以自动推导出v2的类型
	// v3 := 10   //自动推导出 v3 的类型

	v1 = 1
	v2 = "123"
	v3[0] = 123
	v5.f = 12
	v12 = "1231234123"

	// 多重赋值
	v1, v2 = v5.f, v12

	fmt.Println("v1 =", v1)
	fmt.Println("v2 =", v2)
	fmt.Println("v3 =", v3)
	fmt.Println("v4 =", v4)
	fmt.Println("v5 =", v5)
	fmt.Println("v6 =", v6)
	fmt.Println("v7 =", v7)
	fmt.Println("v8 =", v8)
	fmt.Println("v11 =", v11)
	fmt.Println("v12 =", v12)

	fmt.Println("hello, world ")

	// 匿名变量
	_, _, nickName := GetName()
	fmt.Println("nickName: ", nickName)

}


```
