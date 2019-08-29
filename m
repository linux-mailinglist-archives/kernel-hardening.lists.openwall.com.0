Return-Path: <kernel-hardening-return-16825-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 248ACA1A2F
	for <lists+kernel-hardening@lfdr.de>; Thu, 29 Aug 2019 14:36:40 +0200 (CEST)
Received: (qmail 26473 invoked by uid 550); 29 Aug 2019 12:36:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 26440 invoked from network); 29 Aug 2019 12:36:33 -0000
Date: Thu, 29 Aug 2019 07:36:21 -0500 (CDT)
From: Christopher M Riedl <cmr@informatik.wtf>
To: Daniel Axtens <dja@axtens.net>, linuxppc-dev@ozlabs.org,
	kernel-hardening@lists.openwall.com
Cc: ajd@linux.ibm.com
Message-ID: <4809745.37851.1567082181205@privateemail.com>
In-Reply-To: <87d0gov2l5.fsf@dja-thinkpad.axtens.net>
References: <20190828034613.14750-1-cmr@informatik.wtf>
 <20190828034613.14750-3-cmr@informatik.wtf>
 <87d0gov2l5.fsf@dja-thinkpad.axtens.net>
Subject: Re: [PATCH v5 2/2] powerpc/xmon: Restrict when kernel is locked
 down
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.8.4-Rev60
X-Originating-Client: open-xchange-appsuite
X-Virus-Scanned: ClamAV using ClamSMTP


> On August 29, 2019 at 2:43 AM Daniel Axtens <dja@axtens.net> wrote:
> 
> 
> Hi,
> 
> > Xmon should be either fully or partially disabled depending on the
> > kernel lockdown state.
> 
> I've been kicking the tyres of this, and it seems to work well:
> 
> Tested-by: Daniel Axtens <dja@axtens.net>
> 

Thank you for taking the time to test this!

>
> I have one small nit: if I enter confidentiality mode and then try to
> enter xmon, I get 32 messages about clearing the breakpoints each time I
> try to enter xmon:
>

Ugh, that's annoying. I tested this on a vm w/ 2 vcpus but should have
considered the case of more vcpus :(

> 
> root@dja-guest:~# echo confidentiality > /sys/kernel/security/lockdown 
> root@dja-guest:~# echo x >/proc/sysrq-trigger 
> [  489.585400] sysrq: Entering xmon
> xmon: Disabled due to kernel lockdown
> xmon: All breakpoints cleared
> xmon: All breakpoints cleared
> xmon: All breakpoints cleared
> xmon: All breakpoints cleared
> xmon: All breakpoints cleared
> ...
> 
> Investigating, I see that this is because my vm has 32 vcpus, and I'm
> getting one per CPU.
> 
> Looking at the call sites, there's only one other caller, so I think you
> might be better served with this:
> 
> diff --git a/arch/powerpc/xmon/xmon.c b/arch/powerpc/xmon/xmon.c
> index 94a5fada3034..fcaf1d568162 100644
> --- a/arch/powerpc/xmon/xmon.c
> +++ b/arch/powerpc/xmon/xmon.c
> @@ -3833,10 +3833,6 @@ static void clear_all_bpt(void)
>                 iabr = NULL;
>                 dabr.enabled = 0;
>         }
> -
> -       get_output_lock();
> -       printf("xmon: All breakpoints cleared\n");
> -       release_output_lock();
>  }
>  
>  #ifdef CONFIG_DEBUG_FS
> @@ -3846,8 +3842,13 @@ static int xmon_dbgfs_set(void *data, u64 val)
>         xmon_init(xmon_on);
>  
>         /* make sure all breakpoints removed when disabling */
> -       if (!xmon_on)
> +       if (!xmon_on) {
>                 clear_all_bpt();
> +               get_output_lock();
> +               printf("xmon: All breakpoints cleared\n");
> +               release_output_lock();
> +       }
> +
>         return 0;
>  }
>

Good point, I will add this to the next version, thanks!  

>
> Apart from that:
> Reviewed-by: Daniel Axtens <dja@axtens.net>
> 
> Regards,
> Daniel
>
