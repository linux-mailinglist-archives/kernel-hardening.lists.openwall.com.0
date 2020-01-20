Return-Path: <kernel-hardening-return-17589-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id AB914142113
	for <lists+kernel-hardening@lfdr.de>; Mon, 20 Jan 2020 01:28:15 +0100 (CET)
Received: (qmail 2040 invoked by uid 550); 20 Jan 2020 00:28:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 2020 invoked from network); 20 Jan 2020 00:28:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=grJBsBW5UG1B6mPNLbLI6oPV5GDmPh5C8rRMjFYC2Sk=;
        b=iacvyraMagb4tQg7urkpdYkKBChF3lFIo70pNip5shda1UwtdbaTlEQmN1C56SGI7n
         IY3sgbs1w4hQPDJ+MHbymreZDpiONlv09MjcnYGlC4zWxhIIhx1qWQMpzY/6cwjFFuCV
         KZVBTv94yC14sEc+0AyfuGhI+JURC3m2d5+w0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=grJBsBW5UG1B6mPNLbLI6oPV5GDmPh5C8rRMjFYC2Sk=;
        b=iH+qOsOKoln22znD0086j8LTksB9OXJAUXCzinpFbGwX/DuRF7PM8gkxSJ1IZ3G2A0
         +ucAGMeXSKVF1Hx3zzKU4cL/bnViM8KY/xLRlsLQQrz+H6rk6ln6LD84dbPHWEJwGps8
         doWwnQqt2Js4/nFSAsx5igmgzDgUMP8bLP6r1YtLVBAO5GwC7oJRItCakNQfn0cIYkfO
         ci9giXqRt9LuL74jcD8HxbCAcDRSjdRK0BLOklafv7SGDPunxmJQyY4JbhmylKxjvtbr
         BELYJ/XpL9gwzc1KixT5q8vfApNVOPNdtwldZGLuOrCdGF1VGc8JzYpOv4qNKEx60Dt+
         tJww==
X-Gm-Message-State: APjAAAXWfkTneBJEl1wCqmdk7M7wkSCnQOi2gglg0wCdMHmG2qzlF9Gd
	Y8D9vGGv4cpyDx2e3j8U7jrLCQ==
X-Google-Smtp-Source: APXvYqzxLq9Mg1sgqL47k35xEK5OE2a3imCJ1Ludv9JDdFjeOeChh35ZG5jcLxCzHMB8PEO4+UbMRw==
X-Received: by 2002:a17:90a:246d:: with SMTP id h100mr19682313pje.127.1579480074782;
        Sun, 19 Jan 2020 16:27:54 -0800 (PST)
From: Daniel Axtens <dja@axtens.net>
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com, Daniel Micay <danielmicay@gmail.com>
Subject: Re: [PATCH] string.h: detect intra-object overflow in fortified string functions
In-Reply-To: <202001180342.B23414E28@keescook>
References: <20200117054050.30144-1-dja@axtens.net> <202001180342.B23414E28@keescook>
Date: Mon, 20 Jan 2020 11:27:50 +1100
Message-ID: <87sgkbj7jt.fsf@dja-thinkpad.axtens.net>
MIME-Version: 1.0
Content-Type: text/plain

Hi Kees,

>> Add a test demonstrating and validating the feature to lkdtm:
>> FORTIFY_SUBOBJECT.
>
> Can you actually split this into two patches? One with the lkdtm changes
> and one with the string.h changes?
Will do.

> I can take the lkdtm changes and then akpm can take the string.h changes
> (please add him as the To for v2, and include lkml in Cc too). (Also,
> it's be nice to have a non-subobject fortify test in lkdtm too.)
(D'oh, both of those are obvious recipients in hind-sight, clearly I
shouldn't send patches right before leaving work on Friday!)

>
> Thanks for doing this! Please consider these:
>
> Reviewed-by: Kees Cook <keescook@chromium.org>

Thanks!

Daniel
>
> -Kees
>
>> 
>> Cc: Daniel Micay <danielmicay@gmail.com>
>> Cc: Kees Cook <keescook@chromium.org>
>> Signed-off-by: Daniel Axtens <dja@axtens.net>
>> ---
>>  drivers/misc/lkdtm/bugs.c  | 26 ++++++++++++++++++++++++++
>>  drivers/misc/lkdtm/core.c  |  1 +
>>  drivers/misc/lkdtm/lkdtm.h |  1 +
>>  include/linux/string.h     | 27 ++++++++++++++++-----------
>>  4 files changed, 44 insertions(+), 11 deletions(-)
>> 
>> diff --git a/drivers/misc/lkdtm/bugs.c b/drivers/misc/lkdtm/bugs.c
>> index a4fdad04809a..1bbe291e44b7 100644
>> --- a/drivers/misc/lkdtm/bugs.c
>> +++ b/drivers/misc/lkdtm/bugs.c
>> @@ -11,6 +11,7 @@
>>  #include <linux/sched/signal.h>
>>  #include <linux/sched/task_stack.h>
>>  #include <linux/uaccess.h>
>> +#include <linux/slab.h>
>>  
>>  #ifdef CONFIG_X86_32
>>  #include <asm/desc.h>
>> @@ -376,3 +377,28 @@ void lkdtm_DOUBLE_FAULT(void)
>>  	panic("tried to double fault but didn't die\n");
>>  }
>>  #endif
>> +
>> +void lkdtm_FORTIFY_SUBOBJECT(void)
>> +{
>> +	struct target {
>> +		char a[10];
>> +		char b[10];
>> +	} target;
>> +	char *src;
>> +
>> +	src = kmalloc(20, GFP_KERNEL);
>> +	strscpy(src, "over ten bytes", 20);
>> +
>> +	pr_info("trying to strcpy past the end of a member of a struct\n");
>> +
>> +	/*
>> +	 * strncpy(target.a, src, 20); will hit a compile error because the
>> +	 * compiler knows at build time that target.a < 20 bytes. Use strcpy()
>> +	 * to force a runtime error.
>> +	 */
>> +	strcpy(target.a, src);
>> +
>> +	/* Use target.a to prevent the code from being eliminated */
>> +	pr_err("FAIL: fortify did not catch an sub-object overrun!\n"
>> +	       "\"%s\" was copied.\n", target.a);
>> +}
>> diff --git a/drivers/misc/lkdtm/core.c b/drivers/misc/lkdtm/core.c
>> index ee0d6e721441..c357e8fece3b 100644
>> --- a/drivers/misc/lkdtm/core.c
>> +++ b/drivers/misc/lkdtm/core.c
>> @@ -117,6 +117,7 @@ static const struct crashtype crashtypes[] = {
>>  	CRASHTYPE(STACK_GUARD_PAGE_TRAILING),
>>  	CRASHTYPE(UNSET_SMEP),
>>  	CRASHTYPE(UNALIGNED_LOAD_STORE_WRITE),
>> +	CRASHTYPE(FORTIFY_SUBOBJECT),
>>  	CRASHTYPE(OVERWRITE_ALLOCATION),
>>  	CRASHTYPE(WRITE_AFTER_FREE),
>>  	CRASHTYPE(READ_AFTER_FREE),
>> diff --git a/drivers/misc/lkdtm/lkdtm.h b/drivers/misc/lkdtm/lkdtm.h
>> index c56d23e37643..45928e25a3a5 100644
>> --- a/drivers/misc/lkdtm/lkdtm.h
>> +++ b/drivers/misc/lkdtm/lkdtm.h
>> @@ -31,6 +31,7 @@ void lkdtm_UNSET_SMEP(void);
>>  #ifdef CONFIG_X86_32
>>  void lkdtm_DOUBLE_FAULT(void);
>>  #endif
>> +void lkdtm_FORTIFY_SUBOBJECT(void);
>>  
>>  /* lkdtm_heap.c */
>>  void __init lkdtm_heap_init(void);
>> diff --git a/include/linux/string.h b/include/linux/string.h
>> index 3b8e8b12dd37..e7f34c3113f8 100644
>> --- a/include/linux/string.h
>> +++ b/include/linux/string.h
>> @@ -319,7 +319,7 @@ void __write_overflow(void) __compiletime_error("detected write beyond size of o
>>  #if !defined(__NO_FORTIFY) && defined(__OPTIMIZE__) && defined(CONFIG_FORTIFY_SOURCE)
>>  __FORTIFY_INLINE char *strncpy(char *p, const char *q, __kernel_size_t size)
>>  {
>> -	size_t p_size = __builtin_object_size(p, 0);
>> +	size_t p_size = __builtin_object_size(p, 1);
>>  	if (__builtin_constant_p(size) && p_size < size)
>>  		__write_overflow();
>>  	if (p_size < size)
>> @@ -329,7 +329,7 @@ __FORTIFY_INLINE char *strncpy(char *p, const char *q, __kernel_size_t size)
>>  
>>  __FORTIFY_INLINE char *strcat(char *p, const char *q)
>>  {
>> -	size_t p_size = __builtin_object_size(p, 0);
>> +	size_t p_size = __builtin_object_size(p, 1);
>>  	if (p_size == (size_t)-1)
>>  		return __builtin_strcat(p, q);
>>  	if (strlcat(p, q, p_size) >= p_size)
>> @@ -340,7 +340,7 @@ __FORTIFY_INLINE char *strcat(char *p, const char *q)
>>  __FORTIFY_INLINE __kernel_size_t strlen(const char *p)
>>  {
>>  	__kernel_size_t ret;
>> -	size_t p_size = __builtin_object_size(p, 0);
>> +	size_t p_size = __builtin_object_size(p, 1);
>>  
>>  	/* Work around gcc excess stack consumption issue */
>>  	if (p_size == (size_t)-1 ||
>> @@ -355,7 +355,7 @@ __FORTIFY_INLINE __kernel_size_t strlen(const char *p)
>>  extern __kernel_size_t __real_strnlen(const char *, __kernel_size_t) __RENAME(strnlen);
>>  __FORTIFY_INLINE __kernel_size_t strnlen(const char *p, __kernel_size_t maxlen)
>>  {
>> -	size_t p_size = __builtin_object_size(p, 0);
>> +	size_t p_size = __builtin_object_size(p, 1);
>>  	__kernel_size_t ret = __real_strnlen(p, maxlen < p_size ? maxlen : p_size);
>>  	if (p_size <= ret && maxlen != ret)
>>  		fortify_panic(__func__);
>> @@ -367,8 +367,8 @@ extern size_t __real_strlcpy(char *, const char *, size_t) __RENAME(strlcpy);
>>  __FORTIFY_INLINE size_t strlcpy(char *p, const char *q, size_t size)
>>  {
>>  	size_t ret;
>> -	size_t p_size = __builtin_object_size(p, 0);
>> -	size_t q_size = __builtin_object_size(q, 0);
>> +	size_t p_size = __builtin_object_size(p, 1);
>> +	size_t q_size = __builtin_object_size(q, 1);
>>  	if (p_size == (size_t)-1 && q_size == (size_t)-1)
>>  		return __real_strlcpy(p, q, size);
>>  	ret = strlen(q);
>> @@ -388,8 +388,8 @@ __FORTIFY_INLINE size_t strlcpy(char *p, const char *q, size_t size)
>>  __FORTIFY_INLINE char *strncat(char *p, const char *q, __kernel_size_t count)
>>  {
>>  	size_t p_len, copy_len;
>> -	size_t p_size = __builtin_object_size(p, 0);
>> -	size_t q_size = __builtin_object_size(q, 0);
>> +	size_t p_size = __builtin_object_size(p, 1);
>> +	size_t q_size = __builtin_object_size(q, 1);
>>  	if (p_size == (size_t)-1 && q_size == (size_t)-1)
>>  		return __builtin_strncat(p, q, count);
>>  	p_len = strlen(p);
>> @@ -502,11 +502,16 @@ __FORTIFY_INLINE void *kmemdup(const void *p, size_t size, gfp_t gfp)
>>  /* defined after fortified strlen and memcpy to reuse them */
>>  __FORTIFY_INLINE char *strcpy(char *p, const char *q)
>>  {
>> -	size_t p_size = __builtin_object_size(p, 0);
>> -	size_t q_size = __builtin_object_size(q, 0);
>> +	size_t p_size = __builtin_object_size(p, 1);
>> +	size_t q_size = __builtin_object_size(q, 1);
>> +	size_t size;
>>  	if (p_size == (size_t)-1 && q_size == (size_t)-1)
>>  		return __builtin_strcpy(p, q);
>> -	memcpy(p, q, strlen(q) + 1);
>> +	size = strlen(q) + 1;
>> +	/* test here to use the more stringent object size */
>> +	if (p_size < size)
>> +		fortify_panic(__func__);
>> +	memcpy(p, q, size);
>>  	return p;
>>  }
>>  
>> -- 
>> 2.20.1
>> 
>
> -- 
> Kees Cook
