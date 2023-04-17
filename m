Return-Path: <kernel-hardening-return-21661-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by mail.lfdr.de (Postfix) with SMTP id C79226E42AA
	for <lists+kernel-hardening@lfdr.de>; Mon, 17 Apr 2023 10:35:32 +0200 (CEST)
Received: (qmail 10054 invoked by uid 550); 17 Apr 2023 08:35:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 10029 invoked from network); 17 Apr 2023 08:35:20 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681720520; x=1713256520;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=KQKMQzANVKqNtf39NTwsnWOCUrSFAGGlqy9Jfahixws=;
  b=Z5/SNs0CPSbLE0rY5RZRqZ+LNBOpdSC72doCRWfu+MctTwFVKUzlIYLB
   vgjp+SuSblbENt2oYNtqz1nQOpt16SpMRtiTbxQ3IXiIoWCnGkqI+z2tE
   YQGthcOf+Ul2Qo/b9n3+Bh4Lu9/VcYNRMlObmSiILsAZcsIyDx+Yv9wic
   x0HSMWdp65BqL6iZa5LeSop3ok3kI4QcdaKH3I8tixpusvxxXYoVQtF4F
   ykqUXECNwSQMP1l5LfwwPD3u2cyZUPDsVubuSxkgrIhAitmL/LpIIx0Bj
   tDOjX6+XWy14TLYh6m7uDLRwCTrzUNWdAFogFW0a1rxBVkCWhpiB2ryFD
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10682"; a="343593695"
X-IronPort-AV: E=Sophos;i="5.99,203,1677571200"; 
   d="scan'208";a="343593695"
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10682"; a="1020340016"
X-IronPort-AV: E=Sophos;i="5.99,203,1677571200"; 
   d="scan'208";a="1020340016"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WxH53fyfkW/yeIo6ZjgSLizFgmIalhYBHCBd/mFFhBDz3D3sennQ45HLQAKtBaQFpRYJZN5QeFgeZKfqczNKjQ1o9cqnIobw20abUrImbjNFPu2IY2zNV6tKK1MlUIPKT+cV7I0iTn+CF0Sd+tOL6u0B6YydbWiOxE3nup6xS9xKMWYJp4FrxFmQVDkPMJdVZaoYyyYWsf4hpR8JQziePTj4HusqdL0DoeH3Qpbqnh0Cqed91b6Ur+s/3E5nG4yzTkTpXtIwCAEKHPyoDCDzweZ92zhBslJm/P5+zx5SGDMNzgUERGiJGWnN0o5OJgfGnX8PKP5f45hPeczQ0S9p9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KQKMQzANVKqNtf39NTwsnWOCUrSFAGGlqy9Jfahixws=;
 b=fyYnDLOo/16g4VuJIEkDTc3bkjGeioxD10pmyouGWbejvjgXmDWnilbIg6qoVHDNFTJPbjeQdqYG9yGgC0oDs3vckFyE2g/Bfn349QJgDpE/Rxlvo3AdUH04tpQTf+592v8Rj9Zr6p9qkrU4v1GpV/9KlV7adfwk81JS8oLtRbh2MEn7BkzyYI3NMP02AneVGFXAkOqZEOxGi032n0ItbMt9Wur0utYzHsbSGShxloJalMZGOfVVhgOv8P5W7OW2xLWvoL+YqOX2AO6rmElxbdmyhXGV7N33MbMD3neI3xqNhgYDVovuqzunnmJn32VUD8+i3BWHsXtmPXuuWARGZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: "linux-security-module@vger.kernel.org"
	<linux-security-module@vger.kernel.org>
CC: "lss-pc@lists.linuxfoundation.org" <lss-pc@lists.linuxfoundation.org>,
	"lwn@lwn.net" <lwn@lwn.net>, Linux Kernel Mailing List
	<linux-kernel@vger.kernel.org>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, Kernel Hardening
	<kernel-hardening@lists.openwall.com>, "linux-integrity@vger.kernel.org"
	<linux-integrity@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "selinux@vger.kernel.org"
	<selinux@vger.kernel.org>, Audit-ML <linux-audit@redhat.com>,
	"tpmdd-devel@lists.sourceforge.net" <tpmdd-devel@lists.sourceforge.net>,
	"keyrings@vger.kernel.org" <keyrings@vger.kernel.org>
Subject: [ANNOUNCE] [CFP] Linux Security Summit Europe (LSS-EU)
Thread-Topic: [ANNOUNCE] [CFP] Linux Security Summit Europe (LSS-EU)
Thread-Index: AdlxBvhHhF6rbpsrQ7SOGxoWhhjmbw==
Date: Mon, 17 Apr 2023 08:35:04 +0000
Message-ID: <DM8PR11MB57509BF8C3350944A3DB0A8FE79C9@DM8PR11MB5750.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5750:EE_|MN2PR11MB4519:EE_
x-ms-office365-filtering-correlation-id: 79f4193e-2676-4bd1-4979-08db3f1ea45b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HeSlJcRl8mo/Dpk2KCJzmHFfhR3gshk97opStzk9T6WysLZPJMeWlqEWqcmyxFxqJMvDlYRqzp3jijRcoGcEJ8taDHSo4SSQJiRP9+C8+w8bpVru+ZxaPFrIQoZJP9Dcsd24qwXW83/8xCdwx784ENJr+Ewa/1gONjfGD38PZCGS2IykGo1qAGuPdlgXKqujYUyCiMcnD0gUqvBBXJto7csJ+bXv4x8NlBcVd9mr423FvvyYZpW+5gnbW5/jSMjJkWQW0JQS9dC0ClTYlVw4BzO70xFYsk3rh5szgWrql5mzl45Zqshb4el9bRHmZR93NBhd39NTFLW8I3LaWN+OQVguiknKPIX4wAn1Or4feXsQkTqNS3TcV49UWeGoDrQgZFYWW3kBzIcQ21owouBFoN4gLLDpfXrrsNjVOvSLLPha4v19TqdZ7Z1pf6YDtLjJMEBh3uzTr6pAkchvmZRGHOEj7wREjuOZ+tGB7iKcgoA03KZALc86IGNhSyp0Xr33IBR9O8LAdhV2MNrMGWsjiaGo6Q4TZkxn5JlxSLQaLNyZ60G9hb/nx2XJ3AiUv3A09KoSeEAZfZ5V+3gxi8jYaP08mO/3shnWFCaofEYCC3tI3qtJUriVDR8QGFo9MseFhnbCtL4/TXraG4kE8Eobyw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5750.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(136003)(366004)(396003)(376002)(451199021)(55016003)(66476007)(76116006)(66946007)(82960400001)(66556008)(66446008)(64756008)(6916009)(4326008)(478600001)(316002)(54906003)(5660300002)(52536014)(8676002)(15650500001)(7416002)(41300700001)(122000001)(8936002)(38100700002)(186003)(83380400001)(9686003)(71200400001)(7696005)(26005)(6506007)(4744005)(966005)(33656002)(86362001)(38070700005)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VW9weTNiNENPWmhLQ1RiT1NIQzcxNHlXN0lHa29RSzdNUW5VY3dYVDNkcWY1?=
 =?utf-8?B?R29Qc2Y4NFg3TEQyb3BJSVlzaWttS2hQaE9LWHk0aFZmL2Vaclh0NTdEdXgx?=
 =?utf-8?B?QmtTd0RQOWQ0emJMYU8zQjBheWllQndkOXhtZ2VGZHYzYTV6TU14RElkN29v?=
 =?utf-8?B?a3R0bTRvaWU5eldJUlNpWW5CUkxKa2xxcGk5RDZKMzJZSitKcmMvbFNxRDRC?=
 =?utf-8?B?Ykx1bVN2UzI5dU1KRU5DQ1lOMHlRZjN1ZWN6SHZ1cHJNNHJKSWxVNG5NM3l0?=
 =?utf-8?B?a0gwdThvcGRMSmt5OVd3enNMY3dwTnRIVnh1Zk8wTzgxeUxKWXRidS9CYzdh?=
 =?utf-8?B?S3ROVkFtVVd6Zmxid0NlNDA1WDBBQ2drZDRqQll2NHR1OTVFVXZGQkRVZU5o?=
 =?utf-8?B?R3ljK1U3N1h6WWhrNmhiUElHMXljcjFHMzRzME9wRVZucXF2SjFkcXNxWXpk?=
 =?utf-8?B?VksxZHVmb08raTFVZUlvWmVwYXNkc0VIa3hnaUVDZlV0eXMxOEdXTW5od2xG?=
 =?utf-8?B?eWsxa1FxdU4wYjhzQmIyL0NmQU1sZzJIL1dlM2NETGNvdTNBVG1nL0pOaEdn?=
 =?utf-8?B?ajRNM01LNmFrNTgvd0huRnptK0N1ekJQSllpRktLbjNaeEsyb3RLVVRpdk9y?=
 =?utf-8?B?bENxQXlpYmIvVExxeUxGZmg1bzlKdVlYQ3V1ajV6SUs3NGtmbXBmWWsxK2hD?=
 =?utf-8?B?OUZqL0tJUm0yUzBJQTlBbjMxTzdBSm5JcC9jUmlRSUFSeEFqdFdKSkhreDRB?=
 =?utf-8?B?eVkydWdKVnpicW50NUxoK3JtZUVMaUE5WXpxeExwcW5CZHliTGlQaThSdmRi?=
 =?utf-8?B?ak9TZkZVU2MvQVU1dlFGbC9aVjlmTXZna0JNZllQZExUZHdnbTBnV0JwakR1?=
 =?utf-8?B?aFhzeG1WR2pIc29SUndON0R6bmFteHh2UVBmMFZrTGpjc3FoMktybUxZakFD?=
 =?utf-8?B?TDF0U3VoeUdlTW5OQkpydUhLem1qempNSjlzSFYraDVXcFA3RVBqSllVN3Ni?=
 =?utf-8?B?Z25KTkNCb1JnMXVzSzQ4RzlSdVIwMVUzU2ZWWkpaaExoRWJNWDlJWFJBRStj?=
 =?utf-8?B?RG5RQ29sZjNXMTBqOG9aRVpvMGE1RWdBekhXVGNlbytzdE9NcktGb0VkSVFO?=
 =?utf-8?B?ZmYzZ3J0TjdxUHRMek90QlFMQXAxRzEyeEpYRUNjOXdJUkwxMDJHVlpOdGJI?=
 =?utf-8?B?VzNqdVNWYlpiOGkvOTNLT0lLWDk5c2ZrWnplbmRmRW9EZHZMRXZJTlFNTVRZ?=
 =?utf-8?B?dUozUXZQUjlZaFNxQkgxdko1UlBIWmUvNDJOZWUvTkJaaDJWWnk3VnNjTkhV?=
 =?utf-8?B?UEVEaGk0Rld2Q0s4NGgrcnZPdjhiYzlNT3ZVVUgzTDJSMVRweTljSDVaNklT?=
 =?utf-8?B?UEhJbnpwZ3NkVjNxeXhiU1M3V1BqaG15K2liM05lVzd4K1pRUUswRWVBVjdN?=
 =?utf-8?B?Z25RYVZyTjQ4WDhVS3U4V2MrTWJJbGNqcmxyS3V4MXd6bUlORFE4cWxNWE84?=
 =?utf-8?B?ZkpCVXByQS9QMllYMGQ3bXBUVDlnNFVtOU1lNHVLaGVybU5nMXI3ZXpDTkhs?=
 =?utf-8?B?a21rZ3d6YStseUNhMGxtZThNaTd4N2U4TGFTUjh6dWEwaHpJd1RlM2QxcHI1?=
 =?utf-8?B?MGxFMHRxcEE4dVVvdmpNWnNGcG5HZUVyY0dFeTZ3RWJSdW5tSTh1NzBJV2gy?=
 =?utf-8?B?dHN4RGNCQi9oRjVKcy9BSTVVcVZSaEJFTWdMSVlzVm5WeW5wTGt1SEN4ejBS?=
 =?utf-8?B?YjQvZjJjQm1MNlNRWUF0Y3MvS0tPVzhjTEczcmlxdkJEMVdoMk40cXhGZHEr?=
 =?utf-8?B?MmZvcytpSkNGc2N3WnFvZTFINmc2dVg4Tk85cEM1dHRRL0pRWHp1aWZCTXIz?=
 =?utf-8?B?WHdITTBLN3J1MTErd04vZ1NTV3NMNGdvUmRZSjlFY3NORWZrMytteWczU05h?=
 =?utf-8?B?a3YwQW00aU45RXBuSCt6cThRaEFlcWh6dUJ0OGZQY1grNHFJSEUxTTBWRVNK?=
 =?utf-8?B?M0hsSGVBdGI0NDQ2bW55cUxwL2tKZ2NuRWpMaWVlRGVoUTBoVGpsd29ZNnZt?=
 =?utf-8?B?TUNUcTFtdTQ1TmV3djlySHJqaXcvRHN5bG95Z056NklYUmp2S2dYNDAxQklV?=
 =?utf-8?Q?/PIGyDtJrzzYXpq/EMfiZy6Rm?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5750.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79f4193e-2676-4bd1-4979-08db3f1ea45b
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2023 08:35:04.1795
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Yvk0uINt0uTyZ7OH565tzyTk5d+mzjWAmXLAz5+UqaVLx+NNJ8/QPxc9mfDxxUdRwpWBxlNOM9hOJRBvluQrSVDmL8eujUi9XRkA1wrzsUI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4519
X-OriginatorOrg: intel.com

VGhlIENhbGwgZm9yIFBhcnRpY2lwYXRpb24gZm9yIHRoZSAyMDIzIExTUy1FVSBjb25mZXJlbmNl
IGlzIG9wZW4hDQoNClNlZSBkZXRhaWxzIG9mIHRoZSBldmVudCBhbmQgaW5mb3JtYXRpb24gb24g
c3VibWl0dGluZyBwcm9wb3NhbHMgaGVyZToNCmh0dHBzOi8vZXZlbnRzLmxpbnV4Zm91bmRhdGlv
bi5vcmcvbGludXgtc2VjdXJpdHktc3VtbWl0LWV1cm9wZS8NCg0KTFNTLUVVIDIwMjMgd2lsbCBi
ZSBpbiBCaWxiYW8sIFNwYWluLCBmcm9tIFNlcHRlbWJlciAyMHRoIHRvIFNlcHRlbWJlciAyMS4g
DQpUaGlzIHdpbGwgYmUgYSB0d28gZGF5IGV2ZW50LCBjby1sb2NhdGVkIHdpdGggT3BlbiBTb3Vy
Y2UgU3VtbWl0IEV1cm9wZSBbMV0uDQoNClRoZSBMU1MtRVUgQ0ZQIGlzIG9wZW4gdW50aWwgTW9u
ZGF5LCBKdW5lIDUuDQoNCk5vdGUgdGhhdCBhbm5vdW5jZW1lbnRzIHJlbGF0aW5nIHRvIHRoZSBM
aW51eCBTZWN1cml0eSBTdW1taXQgbWF5IGJlIGZvdW5kIA0Kbm93IG9uIHRoZSBGZWRpdmVyc2Us
IHZpYTogaHR0cHM6Ly9zb2NpYWwua2VybmVsLm9yZy9MaW51eFNlY1N1bW1pdA0KDQpCZXN0IFJl
Z2FyZHMsDQpFbGVuYSBSZXNoZXRvdmENCg0KWzFdIGh0dHBzOi8vZXZlbnRzLmxpbnV4Zm91bmRh
dGlvbi5vcmcvb3Blbi1zb3VyY2Utc3VtbWl0LWV1cm9wZS8gDQo=
