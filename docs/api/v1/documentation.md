%{
  title: "The Better PSSO API",
  author: "Daniel Khaapamyaki",
  description: "Learn how to use the better PSSO API"
}
---

# Introduction

Our API accepts form-encoded requests and returns JSON encoded responses. It uses standard HTTP status codes, authentication, and methods in their usual ways.

You can find the source code here: [https://git.coco.study/dkhaapam/better_psso](https://git.coco.study/dkhaapam/better_psso)

# Authentication

The Better PSSO API uses the official [PSSO TH Köln HTTP Basic Auth](https://psso.th-koeln.de/qisserver/rds?state=user&type=7) endpoint.

Your Campusid and Password are encoded using [HTTP Basic Auth](https://tools.ietf.org/html/rfc7617).

```
http https://psso.xyz/api/v1/gradings --auth campusid:password
```

# Gradings

## Endpoints

- GET /gradings

## Examples

```
http https://psso.xyz/api/v1/gradings --auth campusid:password
```

```
[
  {
    "Credits": "4,0",
    "Note": "1,0",
    "PNR": "1311",
    "Pflichtkz.": "PF",
    "Prf.Art": "MO",
    "Prüfungsdatum": "31.01.2020",
    "Prüfungstext": "Project Explore 1",
    "Semester": "WS 19/20",
    "Status": "BE",
    "Vermerk": "",
    "Versuch": "1"
  },
  {
    "Credits": "5,0",
    "Note": "",
    "PNR": "1411",
    "Pflichtkz.": "PF",
    "Prf.Art": "MO",
    "Prüfungsdatum": "23.03.2020",
    "Prüfungstext": "Community & Reflection 1",
    "Semester": "WS 19/20",
    "Status": "BE",
    "Vermerk": "",
    "Versuch": "1"
  },
  ...
]
```