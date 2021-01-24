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

# Certificates

## Endpoints

- GET /certificates
- GET /certificates/:type/:id

## Examples

```
http https://psso.xyz/api/v1/certificates --auth campusid:password
```

```elixir
[
  {
    "links": {
      "bafoeg_bescheinigung": "http://psso.xyz/api/v1/certificates/bafoegbescheinigungSemester/20211",
      "studienbescheinigung": "http://psso.xyz/api/v1/certificates/studienbescheinigungSemester/20211"
    },
    "semester": "Sommersemester 2021"
  },
  {
    "links": {
      "bafoeg_bescheinigung": "http://psso.xyz/api/v1/certificates/bafoegbescheinigungSemester/20202",
      "studienbescheinigung": "http://psso.xyz/api/v1/certificates/studienbescheinigungSemester/20202"
    },
    "semester": "Wintersemester 2020/21"
  },
  {
    "links": {
      "bafoeg_bescheinigung": "http://psso.xyz/api/v1/certificates/bafoegbescheinigungSemester/20201",
      "studienbescheinigung": "http://psso.xyz/api/v1/certificates/studienbescheinigungSemester/20201"
    },
    "semester": "Sommersemester 2020"
  },
  {
    "links": {
      "bafoeg_bescheinigung": "http://psso.xyz/api/v1/certificates/bafoegbescheinigungSemester/20192",
      "studienbescheinigung": "http://psso.xyz/api/v1/certificates/studienbescheinigungSemester/20192"
    },
    "semester": "Wintersemester 2019/20"
  }
]
```

```
http -d http://psso.xyz/api/v1/certificates/studienbescheinigungSemester/20211 --auth campusid:password
```

```elixir
HTTP/1.1 200 OK
cache-control: max-age=0, private, must-revalidate
content-disposition: attachment; filename="studienbescheinigungSemester-20211.pdf"
content-length: 45971
content-type: application/pdf
date: Sun, 24 Jan 2021 20:44:48 GMT
server: Cowboy
x-request-id: XXXXXXXXXXXXXXXXXX

Downloading 44.89 kB to "studienbescheinigungSemester-20211.pdf"
Done. 44.89 kB in 0.03000s (1.46 MB/s)
```

# Gradings

## Endpoints

- GET /gradings

## Examples

```
http https://psso.xyz/api/v1/gradings --auth campusid:password
```

```elixir
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