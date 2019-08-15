Return-Path: <kernel-hardening-return-16792-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id CC1FD8E7C5
	for <lists+kernel-hardening@lfdr.de>; Thu, 15 Aug 2019 11:08:10 +0200 (CEST)
Received: (qmail 17487 invoked by uid 550); 15 Aug 2019 09:08:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 4025 invoked from network); 15 Aug 2019 07:53:19 -0000
Subject: Re: [RFC PATCH v4 1/2] powerpc/xmon: Allow listing active breakpoints
 in read-only mode
To: "Christopher M. Riedl" <cmr@informatik.wtf>, linuxppc-dev@ozlabs.org,
        kernel-hardening@lists.openwall.com
References: <20190815050616.2547-1-cmr@informatik.wtf>
 <20190815050616.2547-2-cmr@informatik.wtf>
From: Andrew Donnellan <ajd@linux.ibm.com>
Date: Thu, 15 Aug 2019 17:52:54 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190815050616.2547-2-cmr@informatik.wtf>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-AU
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19081507-0012-0000-0000-0000033EFF23
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19081507-0013-0000-0000-000021791516
Message-Id: <081d1159-3dd2-4b9b-4936-091ee8cacc6b@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-15_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908150083

On 15/8/19 3:06 pm, Christopher M. Riedl wrote:>   	case 'c':
> +		if (xmon_is_ro) {
> +			printf(xmon_ro_msg);
> +			break;
> +		}
>   		if (!scanhex(&a)) {
>   			/* clear all breakpoints */
>   			for (i = 0; i < NBPTS; ++i)

Clearing breakpoints is probably alright too.

-- 
Andrew Donnellan              OzLabs, ADL Canberra
ajd@linux.ibm.com             IBM Australia Limited

