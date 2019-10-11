---
author: "wuxingzhong"
title: "Kmp算法"
date: 2019-10-11T17:18:30+08:00
draft: false
tags: ["c", "gist"]
# categories:  [""]
image: ""
banner: ""
comments: true     # set false to hide Disqus comments
share: true        # set false to share buttons
menu: ""           # set "main" to add this content to the main menu
---


```C
//kmp算法  2015.08.08

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//生成部分匹配表
int* PartMatchTable(int* table/*in out*/, const char *src)
{
    if(!src || !table)
    {
        return NULL;
    }
    int len = strlen(src);  //字符串长度

    //初始化table 为0 
    memset(table, 0, (len + 1)*sizeof(int) );

    int i, j, k;
    char* ptou = (char*)src ;
    char* pwei = (char*)src ;
    for(i = 0; i< len ; i++)
    {
        //取出字符串 A AB  ABC ABCD  ABCDA ABCDAB ABCDABD
        pwei = ptou + i;
        for(j = 0; j< i; j++)
        {
            //相同长度的前缀和后缀进行比较
            for(k = 0; k<= j; k++)
            {
                //取前缀  //ptou -- ptou +j  单个字符 *(ptou + k)
                //取后缀  pwei - j -- pwei   单个字符 *(pwei - j + k)

                if(*(ptou + k) != *(pwei - j + k))
                {
                    break;
                }
            }
            if(k > j)  //匹配到一个， 记录下来
            {
                table[i] = k;  //k 刚好为匹配长度
            }

        }
    }
    return table;
}

//kmp算法 查找子串, 返回第一个匹配的字符串指针， 否者 返回NULL
char* Kmpstrstr(const char* src, const char *match,const int* table)
{
    if(!src || !match || !table)
    {
        return NULL;
    }
    int SrcLen = strlen(src);  //获取字符串长度
    int MatchLen = strlen(match);
    char* pSrcCur = (char*)src;  // 长串字符指针当前匹配位置
    char* pMatCur =(char*)match; //匹配字符指针当前匹配位置
    int macthLen = 0;  //已匹配长度
    int backLen = 0;  //回退步数
    while((*pMatCur)&& (*pSrcCur) )
    {
        if(*pMatCur == *pSrcCur)
        {
            pSrcCur++ ;
            pMatCur++ ;
        }else
        {
            macthLen = pMatCur - match;  //计算已经匹配的长度
            if(macthLen == 0)
            {
                pSrcCur++ ;
            }else
            {
                backLen = macthLen - table[macthLen - 1] ;  //计算回退步数， 回退步数 = 已匹配的字符数 - 对应的部分匹配值
                pMatCur -= backLen;
            }
        }
    }

    //是否有匹配
    if(!(*pMatCur))
    {
        return pSrcCur - MatchLen ;
    }
    return NULL;
}


void main()
{
    char s1[100] = "BBC ABCDAB ABCDABCDABDE";
    char s2[100] = "DAB";

    printf("请输入源字符串:");
    gets(s1);    //AAABC AAABB

    printf("请输入子字符串:");
    gets(s2);    //AABB

    int table[100] = { 0 };
    //生成部分匹配表
    PartMatchTable(table, s2);

    //kmp查找子串
    char*  res = Kmpstrstr(s1, s2, table);

    if(res != NULL)
    {
        printf("\n%s\n\n", res);
        printf("strstr函数结果:\n");
        printf("%s\n", strstr(s1, s2));
    }else
    {
        printf("\n%s\n", "未找到匹配的字符串");
    }

}
```
