Return-Path: <kernel-hardening-return-21945-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by mail.lfdr.de (Postfix) with SMTP id 93C8DA38946
	for <lists+kernel-hardening@lfdr.de>; Mon, 17 Feb 2025 17:36:20 +0100 (CET)
Received: (qmail 30519 invoked by uid 550); 17 Feb 2025 16:36:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 12207 invoked from network); 17 Feb 2025 12:46:03 -0000
Date: Mon, 17 Feb 2025 06:45:38 -0600
From: "Dr. Greg" <greg@enjellic.com>
To: James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org,
        Linux Security Summit Program Committee <lss-pc@lists.linuxfoundation.org>,
        linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
        linux-integrity@vger.kernel.org, lwn@lwn.net
Subject: Re: [Announce] Linux Security Summit North America 2025 CfP
Message-ID: <20250217124538.GA11605@wind.enjellic.com>
References: <35b17495-427f-549f-6e46-619c56545b34@namei.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35b17495-427f-549f-6e46-619c56545b34@namei.org>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Mon, 17 Feb 2025 06:45:41 -0600 (CST)

On Mon, Feb 10, 2025 at 01:03:02PM -0800, James Morris wrote:

Good morning, I hope the week is starting well for everyone.

> The Call for Participation for the 2025 Linux Security Summit North 
> America (LSS-NA) is now open.
> 
> LSS-NA 2025 is a technical forum for collaboration between Linux 
> developers, researchers, and end-users. Its primary aim is to foster 
> community efforts in deeply analyzing and solving Linux operating system 
> security challenges, including those in the Linux kernel. Presentations 
> are expected to focus deeply on new or improved technology and how it 
> advances the state of practice for addressing these challenges.
>
> Key dates:
> 
>     - CFP Closes:  Monday, March 10 at 11:59 PM MDT / 10:59 PM PDT
>     - CFP Notifications: Monday, March 31
>     - Schedule Announcement: Wednesday, April 2
>     - Presentation Slide Due Date: Tuesday, June 24
>     - Event Dates: Thursday, June 26 ??? Friday, June 27
> 
> Location: Denver, Colorado, USA (co-located with OSS).

I reflected a great deal before responding to this note and finally
elected to do so.  Given the stated desire of this conference to
'focus deeply on new or improved technologies' for advancing the state
of practice in addressing the security challenges facing Linux, and
presumably by extension, the technology industry at large.

I'm not not sure what defines membership in the Linux 'security
community'.  I first presented at the Linux Security Summit in 2015,
James you were moderating the event and sitting in the first row.

If there is a desire by the Linux Foundation to actually promote
security innovation, it would seem the most productive use of
everyone's time would be to have a discussion at this event focusing
on how this can best be accomplished in the context of the current
Linux development environment.

If we have done nothing else with our Quixote/TSEM initiative, I
believe we have demonstrated that Linux security development operates
under the 'omniscient maintainer' model, a concept that is the subject
of significant discussion in other venues of the Linux community:

https://lore.kernel.org/lkml/CAEg-Je9BiTsTmaadVz7S0=Mj3PgKZSu4EnFixf+65bcbuu7+WA@mail.gmail.com/

I'm not here to debate whether that is a good or bad model.  I do
believe, that by definition, it constrains the innovation that can
successfully emerge to something that an 'omniscient' maintainer
understands, feels comfortable with or is not offended by.

It should be lost on no one that the history of the technology
industry has largely been one of disruptive innovation that is
completely missed by technology incumbents.

The future may be the BPF/LSM, although no one has yet publically
demonstrated the ability to implement something on the order of
SeLinux, TOMOYO or Apparmor through that mechanism.  It brings as an
advantage the ability to innovate without constraints as to would be
considered 'acceptable' security.

Unfortunately, a careful review of the LSM mailing list would suggest
that the BPF/LSM, as a solution, is not politically popular in some
quarters of the Linux security community.  There have been public
statements that there isn't much concern if BPF breaks, as the concept
of having external security policy is not something that should be
supported.

We took an alternative approach with TSEM, but after two years of
submissions, no code was ever reviewed.  I'm not here to bitch about
that, however, the simple fact is that two years with no progress is
an eternity in the technology industry, particularly security, and
will serve to drive security innovation out of the kernel.

One can make a reasoned and informed argument that has already
happened.  One of the questions worthy of debate at a conference with
the objectives stated above.

I apologize if these reflections are less than popular but they are
intended to stimulate productive discussion, if the actual intent of
the conference organizers is to focus deeply on new and improved
security technology.

There is far more technology potentially available than there are good
answers to the questions as to how to effectively exploit it.

> James Morris
> <jmorris@namei.org>

Best wishes for a productive week.

As always,
Dr. Greg

The Quixote Project - Flailing at the Travails of Cybersecurity
              https://github.com/Quixote-Project
