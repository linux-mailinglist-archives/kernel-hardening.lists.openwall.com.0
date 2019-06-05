Return-Path: <kernel-hardening-return-16057-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id B02C23552E
	for <lists+kernel-hardening@lfdr.de>; Wed,  5 Jun 2019 04:20:32 +0200 (CEST)
Received: (qmail 24094 invoked by uid 550); 5 Jun 2019 02:20:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 19765 invoked from network); 5 Jun 2019 01:26:31 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=/nrlh7aFLVEP2ZCzsH4xixg65UQfaz0w/Ld25LSQ+5M=;
 b=d8pHV8b0MzIW0QpC7OGVMUbyJ6f9RYKEk7XaJt/sTQfGC18+eZC0CCriXiV0bngFicHe
 Y8/ufwDJDmMOOx9htlx53GWPPC7t9AvFZWIQ5A4sA8Lj2YSYkqQxnGZ8R+1x46jVmr2c
 xW8XsXgSBDDwTMWYP8GeBbTXDdU/JPdnkjHGONBc2f/tbmN+UfBJACK+Y+6RcniJsRoj
 bsK/6asrz17eoWZ2jmLrKon7QVLDM+aHXYrXqyA9ZzUJSaKasuH9W4BHxX3t7zyF4ApJ
 bUSIC+uBswNoV3vsWJsjRTezwHUl1iXaEVyodnEnqZpj1Xy3Qd/wZwAb2hp1XzbaJzMO dQ== 
Date: Tue, 4 Jun 2019 21:24:29 -0400
From: Daniel Jordan <daniel.m.jordan@oracle.com>
To: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc: linux-kernel@vger.kernel.org, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Bjorn Helgaas <bhelgaas@google.com>, Borislav Petkov <bp@alien8.de>,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org,
        kernel-hardening@lists.openwall.com,
        Lai Jiangshan <jiangshanlai@gmail.com>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, neilb@suse.com,
        netdev@vger.kernel.org, oleg@redhat.com,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Pavel Machek <pavel@ucw.cz>, peterz@infradead.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, rcu@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [RFC 4/6] workqueue: Convert for_each_wq to use built-in list
 check
Message-ID: <20190605012429.wmlvlgn4mb4jkvua@ca-dmjordan1.us.oracle.com>
References: <20190601222738.6856-1-joel@joelfernandes.org>
 <20190601222738.6856-5-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190601222738.6856-5-joel@joelfernandes.org>
User-Agent: NeoMutt/20180323-268-5a959c
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9278 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906050006
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9278 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906050006

On Sat, Jun 01, 2019 at 06:27:36PM -0400, Joel Fernandes (Google) wrote:
> list_for_each_entry_rcu now has support to check for RCU reader sections
> as well as lock. Just use the support in it, instead of explictly
> checking in the caller.
> 
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> ---
>  kernel/workqueue.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 9657315405de..91ed7aca16e5 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -424,9 +424,8 @@ static void workqueue_sysfs_unregister(struct workqueue_struct *wq);
>   * ignored.
>   */
>  #define for_each_pwq(pwq, wq)						\
> -	list_for_each_entry_rcu((pwq), &(wq)->pwqs, pwqs_node)		\
> -		if (({ assert_rcu_or_wq_mutex(wq); false; })) { }	\
> -		else
> +	list_for_each_entry_rcu((pwq), &(wq)->pwqs, pwqs_node,		\
> +				 lock_is_held(&(wq->mutex).dep_map))
>  

I think the definition of assert_rcu_or_wq_mutex can also be deleted.
