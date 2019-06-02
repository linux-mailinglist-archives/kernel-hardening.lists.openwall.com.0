Return-Path: <kernel-hardening-return-16038-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id A656B3233F
	for <lists+kernel-hardening@lfdr.de>; Sun,  2 Jun 2019 14:20:45 +0200 (CEST)
Received: (qmail 17612 invoked by uid 550); 2 Jun 2019 12:20:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 17591 invoked from network); 2 Jun 2019 12:20:37 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P8XJjbcSeHXWyfrm0lZNaxFevNGN/ntRWhil7kOzvQw=;
        b=cpm9Wahqojbpp4VkjWfrSzKQi0a2ao6+Snhc7Rw0Q7G2cnlWl4NN+SpMBNDiynHStQ
         e+MwKcJW+v+aBPTP2CMVHQ+2Z75W4hXURUexykVjLm+sx6J//Q5pTVNwqTtc92n26m9x
         wUI8z1LDwo3dz8mT0g1ckf93t0vtaHtsUBp88=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P8XJjbcSeHXWyfrm0lZNaxFevNGN/ntRWhil7kOzvQw=;
        b=g1tTkfopd0E+nltLLUEge5QWpI0MPzcIIDMRpCjovV3RHvF2MZzql2R9OBNwUqmRMT
         vnNCOhMioveVPaGW8MjvzjjBi4VtJdDPn5nGZ/RCrQs4Bw0wwkRT220jIoedTFfCBzgn
         68wvU3C3t+kPPCCPmxDuKMR2CpFH8y/a7rB+u8IEKqbffEf4YASWG4rz0ODmOlZL4894
         Vy32dsIF84hlUHRnQG//tAoMe3PcNqmgBHB9Th5hGQc4Gqfw6VytsgczK4AU6X9qyPhN
         1O9CYPqWl8/EdaUECtvTQqdBYiVTYCTfi3IxScyRSwoVJPiGALZ8nIp5S8rwxJlP+0Zh
         uKmQ==
X-Gm-Message-State: APjAAAXQeOhi624Rsxkdm/c0NrlXAMXCi6ybkMLux4PLKjP5vWMB2NQm
	kh3Lc2MbLuRqRVCnQq61147D4GF6qG7U1y7ljaqz0w==
X-Google-Smtp-Source: APXvYqxoUeTRSI6CtltHxEsRlYpiPonozfm3ENUzJsZRTMHK2FWCrZ71nbqlV68IH4IhR7parmAXCyudOrYXvzl+KNs=
X-Received: by 2002:ac2:4544:: with SMTP id j4mr10895112lfm.176.1559478026242;
 Sun, 02 Jun 2019 05:20:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190601222738.6856-1-joel@joelfernandes.org> <20190601222738.6856-3-joel@joelfernandes.org>
 <20190602070014.GA543@amd>
In-Reply-To: <20190602070014.GA543@amd>
From: Joel Fernandes <joel@joelfernandes.org>
Date: Sun, 2 Jun 2019 08:20:15 -0400
Message-ID: <CAEXW_YT3t4Hb6wKsjXPGng+YbA5rhNRa7OSdZwdN4AKGfVkX3g@mail.gmail.com>
Subject: Re: [RFC 2/6] ipv4: add lockdep condition to fix for_each_entry
To: Pavel Machek <pavel@denx.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, 
	Bjorn Helgaas <bhelgaas@google.com>, Borislav Petkov <bp@alien8.de>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, 
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Josh Triplett <josh@joshtriplett.org>, 
	Kees Cook <keescook@chromium.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Lai Jiangshan <jiangshanlai@gmail.com>, Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org, 
	linux-pci@vger.kernel.org, Linux PM <linux-pm@vger.kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Neil Brown <neilb@suse.com>, 
	netdev <netdev@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	"Paul E. McKenney" <paulmck@linux.ibm.com>, Peter Zilstra <peterz@infradead.org>, 
	"Rafael J. Wysocki" <rjw@rjwysocki.net>, rcu <rcu@vger.kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, 
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sun, Jun 2, 2019 at 3:00 AM Pavel Machek <pavel@denx.de> wrote:
>
> On Sat 2019-06-01 18:27:34, Joel Fernandes (Google) wrote:
> > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
>
> This really needs to be merged to previous patch, you can't break
> compilation in middle of series...
>
> Or probably you need hlist_for_each_entry_rcu_lockdep() macro with
> additional argument, and switch users to it.

Good point. I can also just add a temporary transition macro, and then
remove it in the last patch. That way no new macro is needed.

Thanks!
