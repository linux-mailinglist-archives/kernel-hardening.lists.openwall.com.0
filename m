Return-Path: <kernel-hardening-return-17279-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 7EDE2EF151
	for <lists+kernel-hardening@lfdr.de>; Tue,  5 Nov 2019 00:42:39 +0100 (CET)
Received: (qmail 1918 invoked by uid 550); 4 Nov 2019 23:42:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1898 invoked from network); 4 Nov 2019 23:42:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r7KXOloQM0IlfDWd2ZmUfquqt9+rdW/LWeVsYzZS5Yo=;
        b=oGPkCL7MQlhqPwAizXy81wfFgmEWqswSVaJ070q7QSMUHV4rPFEYIVwwPUoI9JzQsV
         tjGNPbiNdqm3wtOwdKjIJhkvEjEXR8IE1Pm1iGuTui1lsJ+zyZeDnmwaGc2e6IpIiC7j
         9DxB+dahbSm/W3s0bm4fZ+Ya8dVCfIpGNF7eIHGT9X8eK1ysYtT0Awoo+UNrLzgXT1M8
         6lCULIQcB4PBf/VReN8veBI+zOWkOCacAf5D4mMyNLo05/F1kRUX0ZUZHRqR65q2ltF0
         9f1oEkjctFu+UunQvKHg6uh6X+4dlnVuWcEQ+Q7Gr/HjdzHoxvC8WHhHXsbWPLqqmzQT
         XpXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r7KXOloQM0IlfDWd2ZmUfquqt9+rdW/LWeVsYzZS5Yo=;
        b=o4NQBrtn0lBzXpIdSiDdtX0WMs9gsJZXrOzBTLwJ2UGozyQzlVHPE14M5QyuwxD3AY
         9EEMaPVdEx9DYv8aDvnRF2oVBQIQTV0gyEMiUy6ApPRg5e9KnpOgsemkxd6WKtQs2C4q
         CkEPcy3FU12KKbSXM8S65TvUWUzBCvD6H1SJiBS0OQnLx1ewU0xdivHo9t6DIaJuvO2p
         bKKtIYM6UtMaDrFv1p9Tvb4fvrMY/cztyy55GEglNm5yKrP962YtVcY62WYcVKR4zmEU
         Pi0QfRcXHLoIEWF1oLbwMjQ75FF0PN+yzUzypbx4huUWHNhD1hN8nK6dWT0IaAQHtu9y
         3kUw==
X-Gm-Message-State: APjAAAUhCSf2iYkDMp6DTCTR7hsPbK+2+wVWv6LGPclbfUMoQll6fla7
	S2OOi5CKGQzaTsWxt//jeMu+6O6a7IfOsEYvEUj9Kg==
X-Google-Smtp-Source: APXvYqz8I4cRB5IWTivRJgxux0uUc15gQK8/fyRxTXKNu37vOixhqfpx8UpDAvilaBEvuvDWvryENhED0MHmtPoojeg=
X-Received: by 2002:ab0:1451:: with SMTP id c17mr4197520uae.110.1572910941690;
 Mon, 04 Nov 2019 15:42:21 -0800 (PST)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191101221150.116536-1-samitolvanen@google.com> <20191101221150.116536-11-samitolvanen@google.com>
 <20191104170454.GA2024@lakrids.cambridge.arm.com>
In-Reply-To: <20191104170454.GA2024@lakrids.cambridge.arm.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Mon, 4 Nov 2019 15:42:09 -0800
Message-ID: <CABCJKue=yZqe23DYg3_WyiSKhxXS+GXe+3skhvYon4ytkfH+XA@mail.gmail.com>
Subject: Re: [PATCH v4 10/17] arm64: disable kretprobes with SCS
To: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Dave Martin <Dave.Martin@arm.com>, 
	Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, 
	Marc Zyngier <maz@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Nov 4, 2019 at 9:05 AM Mark Rutland <mark.rutland@arm.com> wrote:
> I'm a bit confused as to why that's the case -- could you please
> elaborate on how this is incompatible?
>
> IIUC kretrobes works by patching the function entry point with a BRK, so
> that it can modify the LR _before_ it is saved to the stack. I don't see
> how SCS affects that.

You're correct. While this may not be optimal for reducing attack
surface, I just tested this to confirm that there's no functional
conflict. I'll drop this and related patches from v5.

Sami
