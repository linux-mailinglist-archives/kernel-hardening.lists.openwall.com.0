Return-Path: <kernel-hardening-return-16484-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 58E646AEFB
	for <lists+kernel-hardening@lfdr.de>; Tue, 16 Jul 2019 20:44:25 +0200 (CEST)
Received: (qmail 21508 invoked by uid 550); 16 Jul 2019 18:44:20 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 20461 invoked from network); 16 Jul 2019 18:44:19 -0000
Date: Tue, 16 Jul 2019 11:43:31 -0700
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
Subject: Re: [PATCH 8/9] acpi: Use built-in RCU list checking for
 acpi_ioremaps list (v1)
Message-ID: <20190716184331.GJ14271@linux.ibm.com>
References: <20190715143705.117908-1-joel@joelfernandes.org>
 <20190715143705.117908-9-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190715143705.117908-9-joel@joelfernandes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-16_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907160229

On Mon, Jul 15, 2019 at 10:37:04AM -0400, Joel Fernandes (Google) wrote:
> list_for_each_entry_rcu has built-in RCU and lock checking. Make use of
> it for acpi_ioremaps list traversal.
> 
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>

Given that Rafael acked it, this one looks ready.

							Thanx, Paul

> ---
>  drivers/acpi/osl.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index 9c0edf2fc0dd..2f9d0d20b836 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -14,6 +14,7 @@
>  #include <linux/slab.h>
>  #include <linux/mm.h>
>  #include <linux/highmem.h>
> +#include <linux/lockdep.h>
>  #include <linux/pci.h>
>  #include <linux/interrupt.h>
>  #include <linux/kmod.h>
> @@ -80,6 +81,7 @@ struct acpi_ioremap {
>  
>  static LIST_HEAD(acpi_ioremaps);
>  static DEFINE_MUTEX(acpi_ioremap_lock);
> +#define acpi_ioremap_lock_held() lock_is_held(&acpi_ioremap_lock.dep_map)
>  
>  static void __init acpi_request_region (struct acpi_generic_address *gas,
>  	unsigned int length, char *desc)
> @@ -206,7 +208,7 @@ acpi_map_lookup(acpi_physical_address phys, acpi_size size)
>  {
>  	struct acpi_ioremap *map;
>  
> -	list_for_each_entry_rcu(map, &acpi_ioremaps, list)
> +	list_for_each_entry_rcu(map, &acpi_ioremaps, list, acpi_ioremap_lock_held())
>  		if (map->phys <= phys &&
>  		    phys + size <= map->phys + map->size)
>  			return map;
> @@ -249,7 +251,7 @@ acpi_map_lookup_virt(void __iomem *virt, acpi_size size)
>  {
>  	struct acpi_ioremap *map;
>  
> -	list_for_each_entry_rcu(map, &acpi_ioremaps, list)
> +	list_for_each_entry_rcu(map, &acpi_ioremaps, list, acpi_ioremap_lock_held())
>  		if (map->virt <= virt &&
>  		    virt + size <= map->virt + map->size)
>  			return map;
> -- 
> 2.22.0.510.g264f2c817a-goog
> 
