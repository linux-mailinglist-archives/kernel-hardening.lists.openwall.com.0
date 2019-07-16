Return-Path: <kernel-hardening-return-16480-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 725006AED3
	for <lists+kernel-hardening@lfdr.de>; Tue, 16 Jul 2019 20:40:48 +0200 (CEST)
Received: (qmail 11673 invoked by uid 550); 16 Jul 2019 18:40:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 11594 invoked from network); 16 Jul 2019 18:40:41 -0000
Date: Tue, 16 Jul 2019 11:39:55 -0700
From: "Paul E. McKenney" <paulmck@linux.ibm.com>
To: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc: linux-kernel@vger.kernel.org, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Bjorn Helgaas <bhelgaas@google.com>, Borislav Petkov <bp@alien8.de>,
        c0d1n61at3@gmail.com, "David S. Miller" <davem@davemloft.net>,
        edumazet@google.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org,
        kernel-hardening@lists.openwall.com, kernel-team@android.com,
        Lai Jiangshan <jiangshanlai@gmail.com>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, neilb@suse.com,
        netdev@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Pavel Machek <pavel@ucw.cz>, peterz@infradead.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>, rcu@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, will@kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [PATCH 4/9] ipv4: add lockdep condition to fix for_each_entry
 (v1)
Message-ID: <20190716183955.GF14271@linux.ibm.com>
References: <20190715143705.117908-1-joel@joelfernandes.org>
 <20190715143705.117908-5-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190715143705.117908-5-joel@joelfernandes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-16_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907160228

On Mon, Jul 15, 2019 at 10:37:00AM -0400, Joel Fernandes (Google) wrote:
> Using the previous support added, use it for adding lockdep conditions
> to list usage here.
> 
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>

We need an ack or better from the subsystem maintainer for this one.

						Thanx, Paul

> ---
>  net/ipv4/fib_frontend.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
> index 317339cd7f03..26b0fb24e2c2 100644
> --- a/net/ipv4/fib_frontend.c
> +++ b/net/ipv4/fib_frontend.c
> @@ -124,7 +124,8 @@ struct fib_table *fib_get_table(struct net *net, u32 id)
>  	h = id & (FIB_TABLE_HASHSZ - 1);
>  
>  	head = &net->ipv4.fib_table_hash[h];
> -	hlist_for_each_entry_rcu(tb, head, tb_hlist) {
> +	hlist_for_each_entry_rcu(tb, head, tb_hlist,
> +				 lockdep_rtnl_is_held()) {
>  		if (tb->tb_id == id)
>  			return tb;
>  	}
> -- 
> 2.22.0.510.g264f2c817a-goog
> 
