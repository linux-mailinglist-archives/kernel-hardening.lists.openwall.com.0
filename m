Return-Path: <kernel-hardening-return-20110-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id A28E42848A9
	for <lists+kernel-hardening@lfdr.de>; Tue,  6 Oct 2020 10:33:11 +0200 (CEST)
Received: (qmail 15410 invoked by uid 550); 6 Oct 2020 08:33:04 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 15390 invoked from network); 6 Oct 2020 08:33:04 -0000
Date: Tue, 6 Oct 2020 08:32:52 +0000 (UTC)
From: Christopher Lameter <cl@linux.com>
X-X-Sender: cl@www.lameter.com
To: Matthew Wilcox <willy@infradead.org>
cc: Jann Horn <jannh@google.com>, Alexander Popov <alex.popov@linux.com>, 
    Kees Cook <keescook@chromium.org>, Will Deacon <will@kernel.org>, 
    Andrey Ryabinin <aryabinin@virtuozzo.com>, 
    Alexander Potapenko <glider@google.com>, 
    Dmitry Vyukov <dvyukov@google.com>, Pekka Enberg <penberg@kernel.org>, 
    David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    Masahiro Yamada <masahiroy@kernel.org>, 
    Masami Hiramatsu <mhiramat@kernel.org>, 
    Steven Rostedt <rostedt@goodmis.org>, 
    Peter Zijlstra <peterz@infradead.org>, 
    Krzysztof Kozlowski <krzk@kernel.org>, 
    Patrick Bellasi <patrick.bellasi@arm.com>, 
    David Howells <dhowells@redhat.com>, 
    Eric Biederman <ebiederm@xmission.com>, 
    Johannes Weiner <hannes@cmpxchg.org>, Laura Abbott <labbott@redhat.com>, 
    Arnd Bergmann <arnd@arndb.de>, 
    Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
    Daniel Micay <danielmicay@gmail.com>, 
    Andrey Konovalov <andreyknvl@google.com>, Pavel Machek <pavel@denx.de>, 
    Valentin Schneider <valentin.schneider@arm.com>, 
    kasan-dev <kasan-dev@googlegroups.com>, Linux-MM <linux-mm@kvack.org>, 
    Kernel Hardening <kernel-hardening@lists.openwall.com>, 
    kernel list <linux-kernel@vger.kernel.org>, notify@kernel.org
Subject: Re: [PATCH RFC v2 0/6] Break heap spraying needed for exploiting
 use-after-free
In-Reply-To: <20201006004414.GP20115@casper.infradead.org>
Message-ID: <alpine.DEB.2.22.394.2010060831300.99155@www.lameter.com>
References: <20200929183513.380760-1-alex.popov@linux.com> <91d564a6-9000-b4c5-15fd-8774b06f5ab0@linux.com> <CAG48ez1tNU_7n8qtnxTYZ5qt-upJ81Fcb0P2rZe38ARK=iyBkA@mail.gmail.com> <20201006004414.GP20115@casper.infradead.org>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII



On Tue, 6 Oct 2020, Matthew Wilcox wrote:

> On Tue, Oct 06, 2020 at 12:56:33AM +0200, Jann Horn wrote:
> > It seems to me like, if you want to make UAF exploitation harder at
> > the heap allocator layer, you could do somewhat more effective things
> > with a probably much smaller performance budget. Things like
> > preventing the reallocation of virtual kernel addresses with different
> > types, such that an attacker can only replace a UAF object with
> > another object of the same type. (That is not an idea I like very much
> > either, but I would like it more than this proposal.) (E.g. some
> > browsers implement things along those lines, I believe.)
>
> The slab allocator already has that functionality.  We call it
> TYPESAFE_BY_RCU, but if forcing that on by default would enhance security
> by a measurable amount, it wouldn't be a terribly hard sell ...

TYPESAFE functionality switches a lot of debugging off because that also
allows speculative accesses to the object after it was freed (requires
for RCU safeness because the object may be freed in an RCU period where
it is still accessed). I do not think you would like that.

