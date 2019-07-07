Return-Path: <kernel-hardening-return-16373-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id AAC63612D3
	for <lists+kernel-hardening@lfdr.de>; Sat,  6 Jul 2019 21:29:17 +0200 (CEST)
Received: (qmail 10190 invoked by uid 550); 6 Jul 2019 19:29:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 10129 invoked from network); 6 Jul 2019 19:29:10 -0000
Date: Sat, 6 Jul 2019 20:28:53 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	Brad Spengler <spender@grsecurity.net>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Christoph Hellwig <hch@infradead.org>,
	James Morris <james.l.morris@oracle.com>,
	Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>,
	PaX Team <pageexec@freemail.hu>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v5 06/12] S.A.R.A.: WX protection
Message-ID: <20190706192852.GO17978@ZenIV.linux.org.uk>
References: <1562410493-8661-1-git-send-email-s.mesoraca16@gmail.com>
 <1562410493-8661-7-git-send-email-s.mesoraca16@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1562410493-8661-7-git-send-email-s.mesoraca16@gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: Al Viro <viro@ftp.linux.org.uk>

On Sat, Jul 06, 2019 at 12:54:47PM +0200, Salvatore Mesoraca wrote:

> +#define sara_warn_or_return(err, msg) do {		\
> +	if ((sara_wxp_flags & SARA_WXP_VERBOSE))	\
> +		pr_wxp(msg);				\
> +	if (!(sara_wxp_flags & SARA_WXP_COMPLAIN))	\
> +		return -err;				\
> +} while (0)
> +
> +#define sara_warn_or_goto(label, msg) do {		\
> +	if ((sara_wxp_flags & SARA_WXP_VERBOSE))	\
> +		pr_wxp(msg);				\
> +	if (!(sara_wxp_flags & SARA_WXP_COMPLAIN))	\
> +		goto label;				\
> +} while (0)

No.  This kind of "style" has no place in the kernel.

Don't hide control flow.  It's nasty enough to reviewers,
but it's pure hell on anyone who strays into your code while
chasing a bug or doing general code audit.  In effect, you
are creating your oh-so-private C dialect and assuming that
everyone who ever looks at your code will start with learning
that *AND* incorporating it into their mental C parser.
I'm sorry, but you are not that important.

If it looks like a function call, a casual reader will assume
that this is exactly what it is.  And when one is scanning
through a function (e.g. to tell if handling of some kind
of refcounts is correct, with twentieth grep through the
tree having brought something in your code into the view),
the last thing one wants is to switch between the area-specific
C dialects.  Simply because looking at yours is sandwiched
between digging through some crap in drivers/target/ and that
weird thing in kernel/tracing/, hopefully staying limited
to 20 seconds of glancing through several functions in your
code.

Don't Do That.  Really.
