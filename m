Return-Path: <kernel-hardening-return-20993-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 90B833424F3
	for <lists+kernel-hardening@lfdr.de>; Fri, 19 Mar 2021 19:41:08 +0100 (CET)
Received: (qmail 16320 invoked by uid 550); 19 Mar 2021 18:41:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 16300 invoked from network); 19 Mar 2021 18:41:02 -0000
Subject: Re: [PATCH v30 10/12] selftests/landlock: Add user space tests
To: Kees Cook <keescook@chromium.org>
Cc: James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>,
 "Serge E . Hallyn" <serge@hallyn.com>, Al Viro <viro@zeniv.linux.org.uk>,
 Andrew Morton <akpm@linux-foundation.org>,
 Andy Lutomirski <luto@amacapital.net>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, Arnd Bergmann
 <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>,
 David Howells <dhowells@redhat.com>, Jeff Dike <jdike@addtoit.com>,
 Jonathan Corbet <corbet@lwn.net>, Michael Kerrisk <mtk.manpages@gmail.com>,
 Richard Weinberger <richard@nod.at>, Shuah Khan <shuah@kernel.org>,
 Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>,
 kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-security-module@vger.kernel.org,
 x86@kernel.org, =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?=
 <mic@linux.microsoft.com>, Dmitry Vyukov <dvyukov@google.com>
References: <20210316204252.427806-1-mic@digikod.net>
 <20210316204252.427806-11-mic@digikod.net> <202103191026.D936362B@keescook>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <e98a1f48-4c35-139d-af88-b6e65fbb5c3f@digikod.net>
Date: Fri, 19 Mar 2021 19:41:00 +0100
User-Agent:
MIME-Version: 1.0
In-Reply-To: <202103191026.D936362B@keescook>
Content-Type: text/plain; charset=iso-8859-15
Content-Language: en-US
Content-Transfer-Encoding: 8bit


On 19/03/2021 18:56, Kees Cook wrote:
> On Tue, Mar 16, 2021 at 09:42:50PM +0100, Micka�l Sala�n wrote:
>> From: Micka�l Sala�n <mic@linux.microsoft.com>
>>
>> Test all Landlock system calls, ptrace hooks semantic and filesystem
>> access-control with multiple layouts.
>>
>> Test coverage for security/landlock/ is 93.6% of lines.  The code not
>> covered only deals with internal kernel errors (e.g. memory allocation)
>> and race conditions.
>>
>> Cc: James Morris <jmorris@namei.org>
>> Cc: Jann Horn <jannh@google.com>
>> Cc: Kees Cook <keescook@chromium.org>
>> Cc: Serge E. Hallyn <serge@hallyn.com>
>> Cc: Shuah Khan <shuah@kernel.org>
>> Signed-off-by: Micka�l Sala�n <mic@linux.microsoft.com>
>> Reviewed-by: Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>
>> Link: https://lore.kernel.org/r/20210316204252.427806-11-mic@digikod.net
> 
> This is terrific. I love the coverage. How did you measure this, BTW?

I used gcov: https://www.kernel.org/doc/html/latest/dev-tools/gcov.html

> To increase it into memory allocation failures, have you tried
> allocation fault injection:
> https://www.kernel.org/doc/html/latest/fault-injection/fault-injection.html

Yes, it is used by syzkaller, but I don't know how to extract this
specific coverage.

> 
>> [...]
>> +TEST(inconsistent_attr) {
>> +	const long page_size = sysconf(_SC_PAGESIZE);
>> +	char *const buf = malloc(page_size + 1);
>> +	struct landlock_ruleset_attr *const ruleset_attr = (void *)buf;
>> +
>> +	ASSERT_NE(NULL, buf);
>> +
>> +	/* Checks copy_from_user(). */
>> +	ASSERT_EQ(-1, landlock_create_ruleset(ruleset_attr, 0, 0));
>> +	/* The size if less than sizeof(struct landlock_attr_enforce). */
>> +	ASSERT_EQ(EINVAL, errno);
>> +	ASSERT_EQ(-1, landlock_create_ruleset(ruleset_attr, 1, 0));
>> +	ASSERT_EQ(EINVAL, errno);
> 
> Almost everywhere you're using ASSERT instead of EXPECT. Is this correct
> (in the sense than as soon as an ASSERT fails the rest of the test is
> skipped)? I do see you using EXPECT is some places, but I figured I'd
> ask about the intention here.

I intentionally use ASSERT as much as possible, but I use EXPECT when an
error could block a test or when it could stop a cleanup (i.e. teardown).

> 
>> +/*
>> + * TEST_F_FORK() is useful when a test drop privileges but the corresponding
>> + * FIXTURE_TEARDOWN() requires them (e.g. to remove files from a directory
>> + * where write actions are denied).  For convenience, FIXTURE_TEARDOWN() is
>> + * also called when the test failed, but not when FIXTURE_SETUP() failed.  For
>> + * this to be possible, we must not call abort() but instead exit smoothly
>> + * (hence the step print).
>> + */
> 
> Hm, interesting. I think this should be extracted into a separate patch
> and added to the test harness proper.

I agree, but it may require some modifications to fit nicely in
kselftest_harness.h . For now, it works well for my use case. I'll send
patches once Landlock is merged. In fact, I already made
kselftest_harness.h available for other users than seccomp. ;)

> 
> Could this be solved with TEARDOWN being called on SETUP failure?

The goal of this helper is to still be able to call TEARDOWN when TEST
failed, not SETUP.

> 
>> +#define TEST_F_FORK(fixture_name, test_name) \
>> +	static void fixture_name##_##test_name##_child( \
>> +		struct __test_metadata *_metadata, \
>> +		FIXTURE_DATA(fixture_name) *self, \
>> +		const FIXTURE_VARIANT(fixture_name) *variant); \
>> +	TEST_F(fixture_name, test_name) \
>> +	{ \
>> +		int status; \
>> +		const pid_t child = fork(); \
>> +		if (child < 0) \
>> +			abort(); \
>> +		if (child == 0) { \
>> +			_metadata->no_print = 1; \
>> +			fixture_name##_##test_name##_child(_metadata, self, variant); \
>> +			if (_metadata->skip) \
>> +				_exit(255); \
>> +			if (_metadata->passed) \
>> +				_exit(0); \
>> +			_exit(_metadata->step); \
>> +		} \
>> +		if (child != waitpid(child, &status, 0)) \
>> +			abort(); \
>> +		if (WIFSIGNALED(status) || !WIFEXITED(status)) { \
>> +			_metadata->passed = 0; \
>> +			_metadata->step = 1; \
>> +			return; \
>> +		} \
>> +		switch (WEXITSTATUS(status)) { \
>> +		case 0: \
>> +			_metadata->passed = 1; \
>> +			break; \
>> +		case 255: \
>> +			_metadata->passed = 1; \
>> +			_metadata->skip = 1; \
>> +			break; \
>> +		default: \
>> +			_metadata->passed = 0; \
>> +			_metadata->step = WEXITSTATUS(status); \
>> +			break; \
>> +		} \
>> +	} \
> 
> This looks like a subset of __wait_for_test()? Could __TEST_F_IMPL() be
> updated instead to do this? (Though the fork overhead might not be great
> for everyone.)

Yes, it will probably be my approach to update kselftest_harness.h .
