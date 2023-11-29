Return-Path: <kernel-hardening-return-21721-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by mail.lfdr.de (Postfix) with SMTP id 42F907FE1AE
	for <lists+kernel-hardening@lfdr.de>; Wed, 29 Nov 2023 22:19:53 +0100 (CET)
Received: (qmail 24028 invoked by uid 550); 29 Nov 2023 21:19:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 24005 invoked from network); 29 Nov 2023 21:19:44 -0000
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.namei.org AD5651E9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=namei.org; s=2;
	t=1701292771; bh=a4+Bn7RqABOY0GmF4sZWzB4XQIxtLMsIpqqVdVd/R/g=;
	h=Date:From:To:cc:Subject:From;
	b=esqokkU6m4nf9dlOK918bRvVgtUX1grKBeAa/6AFK1BFKHD7FLB9T9rZnn2FQju4M
	 FQMGgT6R/+KJxex7roE249lEkPpcB7d7oKrbBWUBxuegkHAwBnS5v3JvCOMceY8GGB
	 OUsmld/soqMTAIKUeFJ3nijvJUEmUYv4888HBa2I=
Date: Wed, 29 Nov 2023 13:19:31 -0800 (PST)
From: James Morris <jmorris@namei.org>
To: linux-security-module@vger.kernel.org
cc: Linux Security Summit Program Committee <lss-pc@lists.linuxfoundation.org>, 
    lwn@lwn.net, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
    kernel-hardening@lists.openwall.com, linux-integrity@vger.kernel.org, 
    Audit-ML <linux-audit@redhat.com>
Subject: [ANNOUNCE] CFP: Linux Security Summit North America 2024
Message-ID: <826fd432-1acf-16be-e7a9-d692aeed23f0@namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


==============================================================================
                   ANNOUNCEMENT AND CALL FOR PARTICIPATION

                   LINUX SECURITY SUMMIT NORTH AMERICA 2024
                             
                                 April 18-19
                              Seattle, WA, USA
==============================================================================

DESCRIPTION
 
Linux Security Summit North America 2024 is a technical forum for
collaboration between Linux developers, researchers, and end-users.  Its
primary aim is to foster community efforts in deeply analyzing and solving
Linux operating system security challenges, including those in the Linux
kernel.

Presentations are expected to focus deeply on new or improved technology and
how it advances the state of practice for addressing these challenges.

The program committee currently seeks proposals for:
 
   * Refereed Presentations:
     45 minutes in length.
 
   * Panel Discussion Topics:
     45 minutes in length.
 
   * Short Topics:
     30 minutes in total, including at least 10 minutes discussion.
 
   * Tutorials
     90 minutes in length.

Tutorial sessions should be focused on advanced Linux security defense
topics within areas such as the kernel, compiler, and security-related
libraries.  Priority will be given to tutorials created for this conference,
and those where the presenter is a leading subject matter expert on the
topic.
 
Topic areas include, but are not limited to:

    * Access Control
    * Case Studies
    * Cryptography and Key Management
    * Emerging Technologies, Threats & Techniques
    * Hardware Security
    * IoT and Embedded Security
    * Integrity Policy and Enforcement
    * Open Source Supply Chain for the Linux OS
    * Security Tools
    * Security UX
    * Linux OS Hardening
    * Virtualization and Containers

Proposals should be submitted via:
    https://events.linuxfoundation.org/linux-security-summit-north-america/


LSS-NA DATES
 
  * CFP close:            Jan 21, 2024
  * CFP notifications:    Feb 06, 2024
  * Schedule announced:   Feb 08, 2024
  * Event:                Apr 18-19, 2024


WHO SHOULD ATTEND
 
We're seeking a diverse range of attendees and welcome participation by
people involved in Linux security development, operations, and research.
 
LSS is a unique global event that provides the opportunity to present and
discuss your work or research with key Linux security community members and
maintainers.  It's also useful for those who wish to keep up with the latest
in Linux security development and to provide input to the development
process.


WEB SITE

    https://events.linuxfoundation.org/linux-security-summit-north-america/


MASTODON

  For event updates and announcements, follow:
    
    https://social.kernel.org/LinuxSecSummit
  
  #linuxsecuritysummit


PROGRAM COMMITTEE

  The program committee for LSS 2024 is:

    * James Morris, Microsoft
    * Serge Hallyn, Cisco
    * Paul Moore, Microsoft
    * Stephen Smalley, NSA
    * Elena Reshetova, Intel
    * John Johansen, Canonical
    * Kees Cook, Google
    * Casey Schaufler
    * Mimi Zohar, IBM
    * David A. Wheeler, Linux Foundation

  The program committee may be contacted as a group via email:
    lss-pc () lists.linuxfoundation.org

