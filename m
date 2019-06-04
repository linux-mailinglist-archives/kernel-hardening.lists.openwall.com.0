Return-Path: <kernel-hardening-return-16049-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 29CA533D90
	for <lists+kernel-hardening@lfdr.de>; Tue,  4 Jun 2019 05:33:22 +0200 (CEST)
Received: (qmail 5489 invoked by uid 550); 4 Jun 2019 03:33:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 32147 invoked from network); 4 Jun 2019 03:28:34 -0000
Subject: Re: [RFC PATCH v2] powerpc/xmon: restrict when kernel is locked down
To: Christopher M Riedl <cmr@informatik.wtf>, linuxppc-dev@ozlabs.org,
        kernel-hardening@lists.openwall.com
Cc: mjg59@google.com, dja@axtens.net
References: <20190524123816.1773-1-cmr@informatik.wtf>
 <81549d40-e477-6552-9a12-7200933279af@linux.ibm.com>
 <1146575236.484635.1559617524880@privateemail.com>
From: Andrew Donnellan <ajd@linux.ibm.com>
Date: Tue, 4 Jun 2019 13:28:13 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <1146575236.484635.1559617524880@privateemail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-AU
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19060403-0012-0000-0000-00000322BA42
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19060403-0013-0000-0000-0000215B96FB
Message-Id: <57844920-c17b-d93c-66c0-e6822af71929@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-04_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=741 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906040021

On 4/6/19 1:05 pm, Christopher M Riedl wrote:>>> +	if (!xmon_is_ro) {
>>> +		xmon_is_ro = kernel_is_locked_down("Using xmon write-access",
>>> +						   LOCKDOWN_INTEGRITY);
>>> +		if (xmon_is_ro) {
>>> +			printf("xmon: Read-only due to kernel lockdown\n");
>>> +			clear_all_bpt();
>>
>> Remind me again why we need to clear breakpoints in integrity mode?
>>
>>
>> Andrew
>>
> 
> I interpreted "integrity" mode as meaning that any changes made by xmon should
> be reversed. This also covers the case when a user creates some breakpoint(s)
> in xmon, exits xmon, and then elevates the lockdown state. Upon hitting the
> first breakpoint and (re-)entering xmon, xmon will clear all breakpoints.
> 
> Xmon can only take action in response to dynamic lockdown level changes when
> xmon is invoked in some manner - if there is a better way I am all ears :)
> 

Integrity mode merely means we are aiming to prevent modifications to 
kernel memory. IMHO leaving existing breakpoints in place is fine as 
long as when we hit the breakpoint xmon is in read-only mode.

(dja/mpe might have opinions on this)

-- 
Andrew Donnellan              OzLabs, ADL Canberra
ajd@linux.ibm.com             IBM Australia Limited

