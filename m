Return-Path: <kernel-hardening-return-21725-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by mail.lfdr.de (Postfix) with SMTP id DC45A87C29D
	for <lists+kernel-hardening@lfdr.de>; Thu, 14 Mar 2024 19:26:22 +0100 (CET)
Received: (qmail 7239 invoked by uid 550); 14 Mar 2024 18:21:58 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 7207 invoked from network); 14 Mar 2024 18:21:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710440774; x=1741976774;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=fOmK+Udmw7Av0zpZN0kTZuY9LLBlbX8pZr052SYheOY=;
  b=gwGkV52TTS77ty2KK/gd03rtapC1h/kIdOf2hIL3RMgic0p7PmsTwdHK
   4pLMj8Y3uk5MLO8vPO1otV4Eg5ozzQd4K917RP9AxT4OA3FI4rcivCkZ0
   O4DoxqQ/q8BpsxyRfhJGgedobggzNy9bfcox2bMDLqkaIiDtUSB5NKDlS
   QUIdm5EdPftsHe8JwOUFBC9lTAHBNuHoxRClErLO06KSkJhN11jTtIVTO
   mkPBWV5xcSP++CvFL+LQvSFKZPT8gRzPdvOOIwuVubznqom4ziUjqNlNc
   3PfkH2ZCv1Y9PGePPBW9jWSOYcDqV6VeCF4eXEvj1cB0yfXtI8hKGqL8K
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11013"; a="5884381"
X-IronPort-AV: E=Sophos;i="6.07,126,1708416000"; 
   d="scan'208";a="5884381"
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,126,1708416000"; 
   d="scan'208";a="12828279"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RZtlG0Qe2fOSv6S/aGlAz5j0V0kfByWnzxXmb4GTs1mSC2A80LVt6NEuTPBCZ8ZpwiHJfxsq3SsYVOsBNJLeoGSutkK2/S8m0MmxcVWWQksh606TgyHmy/AgaqDruGD/NHIvo5PFuQ7mGM55nWsx14bu2AkDoGqFaEHkpWgDH63M8K9TGa1oXrk0hC7eM7XugBRJn5CcYTWdO2p4rm2rqb8kZ913vcbluezvF7PqgamQjkLVDlRwKGDWgRzIDyqitCXnGBtU+DQ4/rr1bEahn4l+v8XZpIli3mrQX/XZn6Ur/qsq+HMnjwG+YJK0QAIn4y5NgnrBeDicwZ/wXyTJmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=46dH6eud1Ey2LL4VFT879hjXXyVPtjUIDTbhoU7ePaU=;
 b=P8hkJ35os7Xmbp4340jriBaY8/c+/Smf/FLWaM/n5MC+JCfSLhtW53FPYkn+bdhHEQ7byStxQBctstjKxsVBGmZn9ajbcAvNLmMHNW39KKsmc9NNCrwXUSF6j9BO9sJ+O5srWnWbTADvOTYIszTwyigPTaio+1XHvPLTmnR3yDBBTd3CokgF20Mga9KTE6V+wHC9SGWHwu99QKZ82tTTg/2BTAs5iohiye6K6vtHE/tB/Pkrr2zgEt8BuLHyiFzEsbAI48kBzOmFogOCcFz7q0pXP+9GktSMAbmG/qpoKLbfwr4OOQjKmOhrV9y/NleBMCq3dhD6k28ysJIppyGhkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Date: Thu, 14 Mar 2024 11:25:50 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "keescook@chromium.org"
	<keescook@chromium.org>
CC: "kernel-hardening@lists.openwall.com"
	<kernel-hardening@lists.openwall.com>, "luto@kernel.org" <luto@kernel.org>,
	"Hansen, Dave" <dave.hansen@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"peterz@infradead.org" <peterz@infradead.org>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "rppt@kernel.org" <rppt@kernel.org>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "linux-hardening@vger.kernel.org"
	<linux-hardening@vger.kernel.org>, "shakeelb@google.com"
	<shakeelb@google.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Williams, Dan
 J" <dan.j.williams@intel.com>, "ardb@google.com" <ardb@google.com>
Subject: Re: [RFC PATCH v2 00/19] PKS write protected page tables
Message-ID: <65f3412e598c8_13f3a29410@iweiny-mobl.notmuch>
References: <20210830235927.6443-1-rick.p.edgecombe@intel.com>
 <202403140927.5A5F290@keescook>
 <3b3c941f1fb69d67706457a30cecc96bfde57353.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3b3c941f1fb69d67706457a30cecc96bfde57353.camel@intel.com>
X-ClientProxiedBy: BYAPR05CA0086.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::27) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|SJ2PR11MB7714:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ce4f391-ad37-4903-106e-08dc44543019
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RQc2sb60WwFxZD2555C0SstnYpN7QGGGLNg/QmrYDG4mF/RhutZU6VCSTFgHAI1KOE6M/meMN408mLrdhPfStqHsyGNLBQkHdBPZQj+eXxAuH3lfCIcVWRui+diLw4Pcw9phhC8QEPFBEpPxgHkHWUDDEMNhl/lgBwo7kw3Vkq4orkYBXt7VqqCX5yTLXgMjcVfWsEZaZlaa86sZ55OH6XUbIDlu1jFzxQX6gVGvjwKxIFUeoLUwBxlD1ooFEdtMG1KLMJy/pkjPAtp3nazFsmJ4U+UkuB4f5tutTeSWIC/ozX4iaPEEW7UptpDKFMM3ly1fycDvzJFzGjANgiL8U2+x1BHWYBZ4GvZcxqytEOv5NJy75qBxEJr0pvcdyobD6qdUhqyCTGn+ZiIUvkl/G3DIMr/E5GW59kYVTjFSy9bj3viVhM+XrzdeJiQ+9cydwCBAXFy/53BVYQ1rujAwlZb0XZ9ltI+98mqvqM6lBd3NYN2J4yctZYY5FIc9Nrhtrn9xPCs6IzVxiAAQtDHrnroznquHitxP7eCFXV6b1pxtEhveXGUounoACtjoDNgxcoASsZ9K4TQKrURaG1TW5d66dUIlEOXUxxprGbHtli4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ooZkKFkMuTazgM2B8m1uNdbsOWR1JLyTs7hSw3gN9Ow+jPagSbYoTWIVoUg3?=
 =?us-ascii?Q?gnwsgr0+sWkYjgBwLP8kK0KXSnTrEmHzuv0XHSGRsDAqInPMe40e8uFF/W6v?=
 =?us-ascii?Q?3yIvle9PqjgExJEdOHD8qCzdj5ylg1qCGxlRTVTT82eAGpNpH62vGlT8v19p?=
 =?us-ascii?Q?CDmuo7ooRDPyQsaehpafH26KUczgovF3BGO8JDXrNiHEe0UUDLBg1x/JtOUS?=
 =?us-ascii?Q?csS6WnOfErDdO8QV371vZFFPUgWG4k68bdqsDGcqbPGwH1R2n89G2vTdQHJ0?=
 =?us-ascii?Q?Qq1cXdmy5UUOxaTlYuY0R6gUdqaVRvFZvKBdfeT8nvSOQNSG+gMRu4cqldmt?=
 =?us-ascii?Q?2b3OfOZSJ5pYrlhVxNZWaK7LVYUhWx88DW1hMPedDybNjEWOA5tMA1wl4xPz?=
 =?us-ascii?Q?guNV64fwSDH5/AtngVHoMMmZmcDMdpRDUuUBaOy2/omN+XyshKD5iwXFCQXT?=
 =?us-ascii?Q?OdD9Pue1SPKHmWmOH/iMUObdzVj0H3c0SR6kfkn+R90st3EE7cwJAL2AW0V7?=
 =?us-ascii?Q?cH9PtwTocrY7RMnpps+Yg5RLPvCUrU9CYRgCvocH5w/WYEZ/1GnYv0XMRAWg?=
 =?us-ascii?Q?VLXCurrSF/fPHE+VOIi0FoY+YufERRBew1y+cQWaD9JB65MhEaz/nBOe4uXn?=
 =?us-ascii?Q?lrztJhHr0lcxS8BMyXnEObbJURTAPLA3kxLM+IkLPIUGnupR/dLKVrHb+CPi?=
 =?us-ascii?Q?vYq2Lia+M+KeEdtCysGSPdAGFsyFy7OzScJXdTUHalLo+MB6/ebkltrqIMfY?=
 =?us-ascii?Q?Ud/ce9LoUgbUTZ6vUxZeKFBwngCoxxU+Ukkdpd6kLI2cok8um2mWRTXLry6N?=
 =?us-ascii?Q?ietHjZuRQZ2t3H8zvIQSA/6QTlxpCJsYHe9SCg3zyB34HHO4K6PLp7xtPUV4?=
 =?us-ascii?Q?ef9j9Er9cnU89YoHrVDP0GzcT+N1fMYdfOrwJHVg8rLmx4gJXiiYogMcS5T4?=
 =?us-ascii?Q?fKwV1KRoNX+cZgK00spOv2IzuI7ErnB4/FyDzB+Oz9B3Nj5Fi6isOfmOs+nP?=
 =?us-ascii?Q?QGMMYjbZOOXR7s9/fWmL96xFQJCYGgEM4IrPkRBkNeCY6vJL/0mutkKZdFFw?=
 =?us-ascii?Q?JMXTnAibA5lbnhF1OgYbUq4Z+urz+dQ5uqlGBRilaWFGeZhZ9P6Cz1+Z6el4?=
 =?us-ascii?Q?VQbJFXb+ZjiWAvJS9QpuVkigdqvuEc1Q+QJCHNmWzzWK6kofrU34ZBkWVTMo?=
 =?us-ascii?Q?xajYgaX7d5MZPu4xkMW0gBFSQr8ri6SuRdwAZPgea7TFHdw1GSMKWeJR22RY?=
 =?us-ascii?Q?8MQThpDhZ8XOLIIL4kNzRGKVsYVgBn5gzDamDiLkJUxblmKbDCB9JKr44W1q?=
 =?us-ascii?Q?xhfSPc/SIoe0G4sfBcNKtQPDv5WpjPrOjbdNwedXXZsXodraiareBIzJX6U7?=
 =?us-ascii?Q?aJMn7WRJH/+CMB16XF/di/g8153LdB5BXclLbPu+hSvixONp30LModfUVAzC?=
 =?us-ascii?Q?kGBE0Z6ntnV5nTfnyXzLMtLkpU1rHWDnxmdqIKuBqBdCPRofnOpbXf+G3SbR?=
 =?us-ascii?Q?VYw8+Voa87+i3HrdsVCJ681JBLzmw/sjYSslDRAl/O9xnqC781pSQcMM/5f5?=
 =?us-ascii?Q?LmAxJjPZFvYy1hXd0eyc2JTA+I8tOw8djOOza3ic?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ce4f391-ad37-4903-106e-08dc44543019
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2024 18:25:55.6460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: balx622iOidQ3dGYbJg8CpTQcTpb//zjo5nc/xCKElgt0cKkyu4tOxnAPhlZUKpu70IS7/164HJWyT4Px9H5gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7714
X-OriginatorOrg: intel.com

Edgecombe, Rick P wrote:
> On Thu, 2024-03-14 at 09:27 -0700, Kees Cook wrote:
> > On Mon, Aug 30, 2021 at 04:59:08PM -0700, Rick Edgecombe wrote:
> > > This is a second RFC for the PKS write protected tables concept.
> > > I'm sharing to
> > > show the progress to interested people. I'd also appreciate any
> > > comments,
> > > especially on the direct map page table protection solution (patch
> > > 17).
> > 
> > *thread necromancy*
> > 
> > Hi,
> > 
> > Where does this series stand? I don't think it ever got merged?
> 
> There are sort of three components to this:
> 1. Basic PKS support. It was dropped after the main use case was
> rejected (pmem stray write protection).

This was the main reason it got dropped.

> 2. Solution for applying direct map permissions efficiently. This
> includes avoiding excessive kernel shootdowns, as well as avoiding
> direct map fragmentation. rppt continued to look at the fragmentation
> part of the problem and ended up arguing that it actually isn't an
> issue [0]. Regardless, the shootdown problem remains for usages like
> PKS tables that allocate so frequently. There is an attempt to address
> both in this series. But given the above, there may be lots of debate
> and opinions.
> 3. The actual protection of the PKS tables (most of this series). It
> got paused when I started to work on CET. In the meantime 1 was
> dropped, and 2 is still open(?). So there is more to work through now,
> then when it was dropped.
> 
> If anyone wants to pick it up, it is fine by me. I can help with
> reviews.

I can help with reviews as well,
Ira

> 
> 
> [0] https://lwn.net/Articles/931406/


