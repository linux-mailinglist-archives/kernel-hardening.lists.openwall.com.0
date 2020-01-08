Return-Path: <kernel-hardening-return-17550-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id E81CA13428C
	for <lists+kernel-hardening@lfdr.de>; Wed,  8 Jan 2020 13:57:12 +0100 (CET)
Received: (qmail 7306 invoked by uid 550); 8 Jan 2020 12:57:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 7272 invoked from network); 8 Jan 2020 12:57:07 -0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hTO9Qm1ZZwl3uYO0jaECi8031SkaBj/3hJsxrnsFLm36F5Tqj5BEdRM2FK+0iC8HpP1vLqe6CJMzI5XmVjZF8PGsrP4Iy/Nl93HPDbtW1X07CQH9VwB0JlSRoCfawbRMncn5g3DxQxFTuVcTTH4qKlR2eglp0sGd7u9bYk8NPUCA590s6T4tsdRIq3DymTCqjqZl3r/wpbNLnZr2S+YbXASENxPgM6Vlc01pcC486YAz26guoSDbh920NPYDkpWl+yxvYdEMsLbOnDAhVIgJffwFl+E67IRMW5xEwowyk3nm10bwNfafd8yI2D92IE1AjilZA6bL0pIoXNe60240mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+sTgG9HSvQ2CKyGEPGd6QXToCB0EOOiRZi+PlCDX+UQ=;
 b=VUKbMxeCt0gAPaRnGk1YSxv08M1+7QVgoqq1ECvAGf3zwW1nANJ+hPlV8gei7fNV8BmkxLaW6FMnZnGyYrCkfoAeUAe9sYnwFWUoPG5bVEl+bS6dv9+Bno0aTiRmqXsKQjTjWPyIWawV7LgF+9EfKbQlvWRBTFP2p4XiGGs1OiGLs8uwhqLvJl3ub7sNEpW2BtsYvtUS3pcIc2ruYQQ416TEIM16SYXD/8izlAaFUt6oUIFXYxoIZiRBGQEpicTzJxqu8b38eFbo+LBm3kzWrsKTFruP74Q9j07p7Kw2lKlr3gnLrfJqTGynZrWyg4qagaGNwk6ygJnxHg8XEYOBcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+sTgG9HSvQ2CKyGEPGd6QXToCB0EOOiRZi+PlCDX+UQ=;
 b=jNzvlyk3FVW9Xso1Q3AgJE/zFrSUYcO81RKZiyCDTiV2ucaY9wqEDD/R7pQqrTJGV+muedmeDIZi0RMFmGKr7BnSQamfcqM87f1bUbajNVZ35nYIPtHtu/WwGrNIdhw4kU9HpxAM9+w3Q0iQxd472Rxz5aSX3AC2r/IfQucoc1M=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Christian.Koenig@amd.com; 
Subject: Re: [PATCH 0/2] drm/radeon: have the callers of set_memory_*() check
 the return value
To: Tianlin Li <tli@digitalocean.com>, kernel-hardening@lists.openwall.com,
 keescook@chromium.org
Cc: Alex Deucher <alexander.deucher@amd.com>, David1.Zhou@amd.com,
 David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
 amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 linux-kernel@vger.kernel.org
References: <20200107192555.20606-1-tli@digitalocean.com>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <b5984995-7276-97d3-a604-ddacfb89bd89@amd.com>
Date: Wed, 8 Jan 2020 13:56:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
In-Reply-To: <20200107192555.20606-1-tli@digitalocean.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: ZR0P278CA0008.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::18) To DM5PR12MB1705.namprd12.prod.outlook.com
 (2603:10b6:3:10c::22)
MIME-Version: 1.0
X-Originating-IP: [2a02:908:1252:fb60:be8a:bd56:1f94:86e7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1dd33c61-1af2-4191-4d62-08d7943a3c6a
X-MS-TrafficTypeDiagnostic: DM5PR12MB1674:|DM5PR12MB1674:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS:
	<DM5PR12MB1674FF1742C90909F5F871CB833E0@DM5PR12MB1674.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 02760F0D1C
X-Forefront-Antispam-Report:
	SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(376002)(136003)(39860400002)(396003)(189003)(199004)(6666004)(66946007)(316002)(5660300002)(54906003)(66556008)(86362001)(81166006)(6486002)(8936002)(2906002)(4326008)(31696002)(478600001)(8676002)(2616005)(31686004)(81156014)(66476007)(52116002)(186003)(36756003)(16526019);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1674;H:DM5PR12MB1705.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	DOr3CxzPuVWhp6oFVFy986YWyopOLvmefkRDil2wAYeUMSYLNnh9M4G8M7YiACFgWSt32MOb1ljoe/OLUiSDdSpKdZxsMGDFPMt5c3wFldaPIWcCojlPxr/aFaALQW8Y3TeDhQIvghuuR4G342cZsGNvmt4Dpnw2veXyP+c2F+b17Rbho0qaKNUcN1eH1uI1Jf+oxz/KS0qut6k5ynnmuM4ZjlwABAGfXWbHhzVctvu4V2taqPhLVGZRwvzQr4IBbGgh8vD5IucIqa+o49VtfZgGd9wU3VONMQN1Wqma/hzE+cCWVNNGBH+GPmrQThOQNOrUbNUJ6uOHI6hDpc7DQ4bvaB2p1KtLsNUS/siACJFFEYGQqRAs7h5X2IhvNLoxcQPvsIYepY03AfLm3lBD4mAWLl+xbAXQsW3IUA3N2wKXMjBQO/gY+/Xr1YqGmvwX
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dd33c61-1af2-4191-4d62-08d7943a3c6a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2020 12:56:54.1496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: miniahrlHlAE68m9mTTBzTnhgAfLYJ9AWQw4nGAoS/eN2tVpymknficg8rD+OJwT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1674

Am 07.01.20 um 20:25 schrieb Tianlin Li:
> Right now several architectures allow their set_memory_*() family of
> functions to fail, but callers may not be checking the return values.
> If set_memory_*() returns with an error, call-site assumptions may be
> infact wrong to assume that it would either succeed or not succeed at
> all. Ideally, the failure of set_memory_*() should be passed up the
> call stack, and callers should examine the failure and deal with it.
>
> Need to fix the callers and add the __must_check attribute. They also
> may not provide any level of atomicity, in the sense that the memory
> protections may be left incomplete on failure. This issue likely has a
> few steps on effects architectures:
> 1)Have all callers of set_memory_*() helpers check the return value.
> 2)Add __must_check to all set_memory_*() helpers so that new uses do
> not ignore the return value.
> 3)Add atomicity to the calls so that the memory protections aren't left
> in a partial state.
>
> This series is part of step 1. Make drm/radeon check the return value of
> set_memory_*().

I'm a little hesitate merge that. This hardware is >15 years old and 
nobody of the developers have any system left to test this change on.

Would it be to much of a problem to just add something like: r = 
set_memory_*(); (void)r; /* Intentionally ignored */.

Apart from that certainly a good idea to add __must_check to the functions.

Regards,
Christian.

>
> Tianlin Li (2):
>    drm/radeon: have the callers of set_memory_*() check the return value
>    drm/radeon: change call sites to handle return value properly.
>
>   drivers/gpu/drm/radeon/r100.c        |  3 ++-
>   drivers/gpu/drm/radeon/radeon.h      |  2 +-
>   drivers/gpu/drm/radeon/radeon_gart.c | 22 ++++++++++++++++++----
>   drivers/gpu/drm/radeon/rs400.c       |  3 ++-
>   4 files changed, 23 insertions(+), 7 deletions(-)
>

