Return-Path: <kernel-hardening-return-16043-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 0D23832DB6
	for <lists+kernel-hardening@lfdr.de>; Mon,  3 Jun 2019 12:33:33 +0200 (CEST)
Received: (qmail 32442 invoked by uid 550); 3 Jun 2019 10:33:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 11368 invoked from network); 3 Jun 2019 05:36:29 -0000
Subject: Re: [RFC PATCH v2] powerpc/xmon: restrict when kernel is locked down
To: "Christopher M. Riedl" <cmr@informatik.wtf>, linuxppc-dev@ozlabs.org,
        kernel-hardening@lists.openwall.com
Cc: mjg59@google.com, dja@axtens.net
References: <20190524123816.1773-1-cmr@informatik.wtf>
From: Andrew Donnellan <ajd@linux.ibm.com>
Date: Mon, 3 Jun 2019 15:36:05 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190524123816.1773-1-cmr@informatik.wtf>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-AU
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19060305-0028-0000-0000-000003742A98
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19060305-0029-0000-0000-00002433FBBD
Message-Id: <81549d40-e477-6552-9a12-7200933279af@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-03_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906030039

On 24/5/19 10:38 pm, Christopher M. Riedl wrote:
> Xmon should be either fully or partially disabled depending on the
> kernel lockdown state.
> 
> Put xmon into read-only mode for lockdown=integrity and completely
> disable xmon when lockdown=confidentiality. Xmon checks the lockdown
> state and takes appropriate action:
> 
>   (1) during xmon_setup to prevent early xmon'ing
> 
>   (2) when triggered via sysrq
> 
>   (3) when toggled via debugfs
> 
>   (4) when triggered via a previously enabled breakpoint
> 
> The following lockdown state transitions are handled:
> 
>   (1) lockdown=none -> lockdown=integrity
>       clear all breakpoints, set xmon read-only mode
> 
>   (2) lockdown=none -> lockdown=confidentiality
>       clear all breakpoints, prevent re-entry into xmon
> 
>   (3) lockdown=integrity -> lockdown=confidentiality
>       prevent re-entry into xmon
> 
> Suggested-by: Andrew Donnellan <ajd@linux.ibm.com>
> Signed-off-by: Christopher M. Riedl <cmr@informatik.wtf>
> ---
> 
> Applies on top of this series:
> 	https://patchwork.kernel.org/cover/10884631/
> 
> I've done some limited testing of the scenarios mentioned in the commit
> message on a single CPU QEMU config.
> 
> v1->v2:
> 	Fix subject line
> 	Submit to linuxppc-dev and kernel-hardening
> 
>   arch/powerpc/xmon/xmon.c | 56 +++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 55 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/xmon/xmon.c b/arch/powerpc/xmon/xmon.c
> index 3e7be19aa208..8c4a5a0c28f0 100644
> --- a/arch/powerpc/xmon/xmon.c
> +++ b/arch/powerpc/xmon/xmon.c
> @@ -191,6 +191,9 @@ static void dump_tlb_44x(void);
>   static void dump_tlb_book3e(void);
>   #endif
>   
> +static void clear_all_bpt(void);
> +static void xmon_init(int);
> +
>   #ifdef CONFIG_PPC64
>   #define REG		"%.16lx"
>   #else
> @@ -291,6 +294,39 @@ Commands:\n\
>     zh	halt\n"
>   ;
>   
> +#ifdef CONFIG_LOCK_DOWN_KERNEL
> +static bool xmon_check_lockdown(void)
> +{
> +	static bool lockdown = false;
> +
> +	if (!lockdown) {
> +		lockdown = kernel_is_locked_down("Using xmon",
> +						 LOCKDOWN_CONFIDENTIALITY);
> +		if (lockdown) {
> +			printf("xmon: Disabled by strict kernel lockdown\n");
> +			xmon_on = 0;
> +			xmon_init(0);
> +		}
> +	}
> +
> +	if (!xmon_is_ro) {
> +		xmon_is_ro = kernel_is_locked_down("Using xmon write-access",
> +						   LOCKDOWN_INTEGRITY);
> +		if (xmon_is_ro) {
> +			printf("xmon: Read-only due to kernel lockdown\n");
> +			clear_all_bpt();

Remind me again why we need to clear breakpoints in integrity mode?


Andrew


> +		}
> +	}
> +
> +	return lockdown;
> +}
> +#else
> +inline static bool xmon_check_lockdown(void)
> +{
> +	return false;
> +}
> +#endif /* CONFIG_LOCK_DOWN_KERNEL */
> +
>   static struct pt_regs *xmon_regs;
>   
>   static inline void sync(void)
> @@ -708,6 +744,9 @@ static int xmon_bpt(struct pt_regs *regs)
>   	struct bpt *bp;
>   	unsigned long offset;
>   
> +	if (xmon_check_lockdown())
> +		return 0;
> +
>   	if ((regs->msr & (MSR_IR|MSR_PR|MSR_64BIT)) != (MSR_IR|MSR_64BIT))
>   		return 0;
>   
> @@ -739,6 +778,9 @@ static int xmon_sstep(struct pt_regs *regs)
>   
>   static int xmon_break_match(struct pt_regs *regs)
>   {
> +	if (xmon_check_lockdown())
> +		return 0;
> +
>   	if ((regs->msr & (MSR_IR|MSR_PR|MSR_64BIT)) != (MSR_IR|MSR_64BIT))
>   		return 0;
>   	if (dabr.enabled == 0)
> @@ -749,6 +791,9 @@ static int xmon_break_match(struct pt_regs *regs)
>   
>   static int xmon_iabr_match(struct pt_regs *regs)
>   {
> +	if (xmon_check_lockdown())
> +		return 0;
> +
>   	if ((regs->msr & (MSR_IR|MSR_PR|MSR_64BIT)) != (MSR_IR|MSR_64BIT))
>   		return 0;
>   	if (iabr == NULL)
> @@ -3742,6 +3787,9 @@ static void xmon_init(int enable)
>   #ifdef CONFIG_MAGIC_SYSRQ
>   static void sysrq_handle_xmon(int key)
>   {
> +	if (xmon_check_lockdown())
> +		return;
> +
>   	/* ensure xmon is enabled */
>   	xmon_init(1);
>   	debugger(get_irq_regs());
> @@ -3763,7 +3811,6 @@ static int __init setup_xmon_sysrq(void)
>   device_initcall(setup_xmon_sysrq);
>   #endif /* CONFIG_MAGIC_SYSRQ */
>   
> -#ifdef CONFIG_DEBUG_FS
>   static void clear_all_bpt(void)
>   {
>   	int i;
> @@ -3785,8 +3832,12 @@ static void clear_all_bpt(void)
>   	printf("xmon: All breakpoints cleared\n");
>   }
>   
> +#ifdef CONFIG_DEBUG_FS
>   static int xmon_dbgfs_set(void *data, u64 val)
>   {
> +	if (xmon_check_lockdown())
> +		return 0;
> +
>   	xmon_on = !!val;
>   	xmon_init(xmon_on);
>   
> @@ -3845,6 +3896,9 @@ early_param("xmon", early_parse_xmon);
>   
>   void __init xmon_setup(void)
>   {
> +	if (xmon_check_lockdown())
> +		return;
> +
>   	if (xmon_on)
>   		xmon_init(1);
>   	if (xmon_early)
> 

-- 
Andrew Donnellan              OzLabs, ADL Canberra
ajd@linux.ibm.com             IBM Australia Limited

