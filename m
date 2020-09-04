Return-Path: <kernel-hardening-return-19783-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 6431325D407
	for <lists+kernel-hardening@lfdr.de>; Fri,  4 Sep 2020 10:55:54 +0200 (CEST)
Received: (qmail 26168 invoked by uid 550); 4 Sep 2020 08:55:47 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 26136 invoked from network); 4 Sep 2020 08:55:46 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6Ph7JbkbFaoWfq28ICsly/8XMu67nEPXs5Q9waIv3f0=; b=O1Wk6g+4dtnT/2kNHdruUhmJV+
	6tEB67TeIbdL+Al5Jn9XY44q6y9lQhurDBfwdtD2w6dxjzl4spbONnX1/Kj3RoZoEDodS0yfasFX3
	S372OJaKBTzpshK5Q6gZ9YlJP2cFOminq4D2m+ZPqghHqvMXLsI91kT1ZAkbUfWdAN1cu2Xo6TgZo
	eoX51+rzTdO5E3cpEnC8uolXotY9q3+nOJCI6AFCcAomERKJIfcW+E1EPFb91rQnk5qLy7cBbUWLq
	O2t8c7qjE6mzHu4WL0RtNjIoZu8mDkM3XCINb38ZwjrOvS+cuffk7p1QSoG9LtYeG+sRoXJxwGWXG
	qZeWJzEA==;
Date: Fri, 4 Sep 2020 10:55:20 +0200
From: peterz@infradead.org
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH v2 00/28] Add support for Clang LTO
Message-ID: <20200904085520.GN2674@hirez.programming.kicks-ass.net>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200903203053.3411268-1-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903203053.3411268-1-samitolvanen@google.com>


Please don't nest series!

Start a new thread for every posting.
