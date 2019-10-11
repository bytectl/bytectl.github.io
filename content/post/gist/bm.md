---
author: "wuxingzhong"
title: "Bm算法"
date: 2019-10-11T17:32:07+08:00
draft: false
tags: ["c"]
categories:  [""]
image: ""
banner: ""
comments: true     # set false to hide Disqus comments
share: true        # set false to share buttons
menu: ""           # set "main" to add this content to the main menu
---


```C

//BM算法  2015.08.10

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//坏字符移动规则
//一个字符在一个字符串中的最后一个位置, 不在则返回 -1 
int CharInStr(const char *src, const char c)
{
    int SrcLen = strlen(src);  //获取字符串长度
    for(int i = SrcLen; i>=0 ; i--)
    {
        if(src[i] == c)
        {
            return i;
        }
    }
    return -1;
}

//好后缀移动规则 返回后移 步数
//s 子串,  cur 当前搜索词位置 
int GoodLastBackLen(char* s, char* cur) 
{	
    //后移位数 = 好后缀的位置 - 搜索词中的上一次出现位置

    //最长好后缀字符
    char* goodBegin = cur + 1;  
    int  goodLen = strlen(goodBegin);

    //好后缀的位置
    int goodPos = strlen(s) - 1; 
    
    int i, j, k;
    //计算 搜索词中的上一次出现位置
    int last = 0 ;
    for(i = 0; i< goodLen ; i++)
    {	
        //取各个好后缀 如: MPLE PLE LE E
        for(j = i, k = 0; j < goodLen ; j++, k++)
        {	
            if(s[k] != goodBegin[j]) //取各个字符 比较
            {
                break;
            }
            if(j == goodLen - 1 &&s[k] == goodBegin[j])
            {
                // 匹配成功
                last = goodLen  - (i +1); 
                return  goodPos - last;
            }
        }
    }

    return goodPos + 1 ;
}

//BM算法 查找子串, 返回第一个匹配的字符串指针， 否者 返回NULL
char* BMstrstr(const char* src, const char *match)
{	
    if(!src || !match )
    {
        return NULL;
    }
    int SrcLen = strlen(src);  //获取字符串长度
    int MatchLen = strlen(match);
    char* pSrcCur = (char*)src + MatchLen - 1;  // 长串字符指针当前匹配位置  
    char* pMatCur =(char*)match + MatchLen - 1; //匹配字符指针当前匹配位置  从尾部开始匹配
    int backLen = 0;  //回退步数
    int goodRuleBackLen = 0; //好后缀规则 回退步数
    while(match -pMatCur != 1 && pSrcCur - src < SrcLen && strlen(pSrcCur) >=strlen(pMatCur))
    {
        if(*pMatCur != *pSrcCur)
        {	
            //坏字符规则
            //后移位数 = 坏字符的位置 - 搜索词中的上一次出现位置
            backLen = ( pMatCur - match ) - CharInStr(match, *pSrcCur);
            if(pMatCur == (char*)match + MatchLen - 1)
            {	//无好后缀， 采用坏字符规则
                pSrcCur += backLen ;  // 相当于子串回退 backLen

            }else
            {
                //"好后缀规则"  
                //后移位数 = 好后缀的位置 - 搜索词中的上一次出现位置
                goodRuleBackLen = GoodLastBackLen((char*)match, pMatCur);
                
                //Boyer-Moore算法的基本思想是，每次后移这两个规则之中的较大值。
                if(goodRuleBackLen > backLen)
                {
                    backLen = goodRuleBackLen; //选择好后缀
                }

                backLen = (backLen + (pMatCur - match + 2));
                //回退不能大于 pSrcCur的长度
                if(backLen > strlen(pSrcCur) -1)
                {
                    backLen = strlen(pSrcCur) - 1;
                }
                pSrcCur += backLen;  // 相当于子串回退 
            }	
            pMatCur = (char*)match + MatchLen - 1; // 移到最后重新开始比
        }
        else
        {
            pMatCur--;
            pSrcCur--;
        }
    }

    //是否有匹配
    if( match -pMatCur == 1 )
    {
        return pSrcCur + 1 ;
    }
    return NULL;

}


void main()
{
    char s1[100] = "  fsd g HERE IS A SIMPLE EXAMPLEabcdabcd";
    char s2[100] = " EXAMPLEabcdabcd";
    
    printf("请输入源字符串:");
    gets(s1);
    
    printf("请输入子字符串:");
    gets(s2);	
    

    //BMstrstr查找子串
    char*  res = BMstrstr(s1, s2);
    
    if(res != NULL)
    {
        printf("\n%s\n\n", res);
    }else
    {
        printf("\n%s\n", "未找到匹配的字符串");
    }
    printf("strstr函数结果:\n");
    printf("%s\n", strstr(s1, s2));

}

```
