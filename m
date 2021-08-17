Return-Path: <kernel-hardening-return-21342-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 50C8D3EEBB9
	for <lists+kernel-hardening@lfdr.de>; Tue, 17 Aug 2021 13:29:41 +0200 (CEST)
Received: (qmail 27881 invoked by uid 550); 17 Aug 2021 11:29:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 17847 invoked from network); 17 Aug 2021 04:04:12 -0000
X-IronPort-AV: E=McAfee;i="6200,9189,10078"; a="216021407"
X-IronPort-AV: E=Sophos;i="5.84,327,1620716400"; 
   d="scan'208";a="216021407"
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,327,1620716400"; 
   d="scan'208";a="505156435"
From: "Ma, XinjianX" <xinjianx.ma@intel.com>
To: "legion@kernel.org" <legion@kernel.org>, "linux-kselftest@vger.kernel.org"
	<linux-kselftest@vger.kernel.org>
CC: lkp <lkp@intel.com>, "linux-kselftest@vger.kernel.org"
	<linux-kselftest@vger.kernel.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "axboe@kernel.dk" <axboe@kernel.dk>,
	"christian.brauner@ubuntu.com" <christian.brauner@ubuntu.com>,
	"containers@lists.linux-foundation.org"
	<containers@lists.linux-foundation.org>, "ebiederm@xmission.com"
	<ebiederm@xmission.com>, "jannh@google.com" <jannh@google.com>,
	"keescook@chromium.org" <keescook@chromium.org>,
	"kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "oleg@redhat.com"
	<oleg@redhat.com>, "torvalds@linux-foundation.org"
	<torvalds@linux-foundation.org>
Subject: Re: [PATCH v11 5/9] Reimplement RLIMIT_MSGQUEUE on top of ucounts
Thread-Topic: [PATCH v11 5/9] Reimplement RLIMIT_MSGQUEUE on top of ucounts
Thread-Index: AQHXkxd6jQPRg5rF3UWHcji9NSI54Q==
Date: Tue, 17 Aug 2021 04:03:50 +0000
Message-ID: <d650b7794e264d5f8aa107644cc9784f@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.239.127.36]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0

Hi Alexey,

When lkp team run kernel selftests, we found after these series of patches,=
 testcase mqueue: mq_perf_tests
in kselftest failed with following message.=20

If you confirm and fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot lkp@intel.com

```
# selftests: mqueue: mq_perf_tests
#
# Initial system state:
#       Using queue path:                       /mq_perf_tests
#       RLIMIT_MSGQUEUE(soft):                  819200
#       RLIMIT_MSGQUEUE(hard):                  819200
#       Maximum Message Size:                   8192
#       Maximum Queue Size:                     10
#       Nice value:                             0
#
# Adjusted system state for testing:
#       RLIMIT_MSGQUEUE(soft):                  (unlimited)
#       RLIMIT_MSGQUEUE(hard):                  (unlimited)
#       Maximum Message Size:                   16777216
#       Maximum Queue Size:                     65530
#       Nice value:                             -20
#       Continuous mode:                        (disabled)
#       CPUs to pin:                            3
# ./mq_perf_tests: mq_open() at 296: Too many open files
not ok 2 selftests: mqueue: mq_perf_tests # exit=3D1
```   =20

Test env:
rootfs: debian-10
gcc version: 9

------
Thanks=20
Ma Xinjian
