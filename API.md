
Web API
-------

GaelSpell is also available as a web service that application 
developers can use for their own projects.  It is currently used
to power the GaelSpell web interface on
[Pota Focal](http://www.potafocal.com/lit/).

To use the API, simply make a HTTP POST request to the URL
`https://cadhan.com/api/gaelspell/1.0`
with one parameters:

* `teacs`: The Irish language text to be checked, as URL-encoded UTF-8

The parameter should be sent in the body of the request
(not as part of the URL), and the request should specify
`Content-Type: application/x-www-form-urlencoded`.

The response will be a JSON array with one entry for each 
misspelling reported by GaelSpell. Each entry is itself an
array with two elements, the first being the misspelled word
and the second being an ordered array of suggested corrections.
If, for example, the value of the `teacs` parameter
is the following string

```
Ba mhath liom abcdefxyz
agus ba mhaith lei é fresin
```

You should get a response resembling this:

```json
[
	["mhath", ["mhaith", "mhaoth", "mheath", "mhaoith", "mhá", "Mhaigh", "Mháigh", "bhaoth", "bhfáth", "mhaígh", "mheádh", "mhioth", "mhéith", "hÁth", "háth"]],
	["abcdefxyz", []],
	["lei", ["léi", "Leo", "leo", "Eli", "LI", "le", "lé", "lí", "leib", "leid", "leis", "léic", "léig", "léim", "léin"]],
	["fresin", ["freisin", "Fresno", "drisín", "frídín", "rísín", "gréasáin", "faisin", "fáisín", "frasaíonn", "réasúin", "réasún", "faraesan", "físeáin", "bhreisínn", "Róisín"]]
]
```

Details
-------

* The suggestions are provided by the aspell spellchecking engine, and
are intended to be ordered in such a way that the most likely 
corrections come first.
* For some misspellings there are no suggestions (as is the case for the second entry in the example above).
* The maximum number of suggestions for any misspelling is currently 15.

HTTP Response Codes
-------------------

* 200 (OK): Successful request
* 400 (Bad Request): Missing parameter in request, empty source text, source text not encoded as UTF-8, etc.
* 403 (Forbidden): Request from unapproved IP address
* 405 (Method Not Allowed): Only POST requests permitted
* 413 (Payload Too Large): Request larger than 16k bytes
* 500 (Internal Server Error): Translation server failed to process request

Access and Rate Limits
-----------

If you'd like to use the API, please contact me directly
(kscanne at gmail) and I will add your IP address to a whitelist.
