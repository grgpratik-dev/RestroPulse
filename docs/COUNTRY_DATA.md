# Country data

`assets/data/countries.json` contains 250 country and territory entries: the
249 ISO 3166-1 entries plus Kosovo (`XK`, a user-assigned code). Territories are
included so the picker can cover residents outside sovereign states. Inclusion
is for geographic selection and does not express a position on sovereignty.

Each entry has:

- `code`: two-letter country identifier; persist this instead of the name.
- `name`: English common display name.
- `flag`: Unicode flag emoji; rendering depends on platform support.
- `defaultCurrencyCode`: suggested currency, or `null` without a universal currency.
- `currencyCodes`: associated active ISO 4217 currency codes; an empty array is valid.

Names are sorted alphabetically, ignoring accents. Default currencies are app
defaults, not an exhaustive statement of legal tender. Keep restaurant currency
separate from country selection. The currency list is not a list of currencies
accepted by every merchant in a country.

## Sources and license

Retrieved on 2026-09-05:

- Country names, codes, flags, and initial currency associations:
  [mledoze/countries](https://github.com/mledoze/countries),
  [source JSON](https://raw.githubusercontent.com/mledoze/countries/master/countries.json).
  Source SHA-256: `99b85dda36895c79caf72e191d035e4b9d82e811ee34f9ca15dfa67d7c561ba8`.
- Currency code validation and corrections:
  [SIX ISO 4217 current currency list](https://www.six-group.com/dam/download/financial-information/data-center/iso-currrency/lists/list-one.xml),
  published 2026-01-01.

The adapted country database is available under the upstream
[Open Database License 1.0](licenses/countries-ODbL-1.0.txt).
Copyright and attribution belong to mledoze/countries and its contributors.
Upstream excludes flags from its ODbL license; this asset stores Unicode emoji,
not upstream flag artwork.

## Transformations and maintenance

Only picker fields are retained. Flags are normalized to Unicode regional
indicator pairs from country codes, filling missing upstream flags.
Non-ISO local currency aliases are omitted.
Corrected currency associations include Cuba (`CUP`), Curaçao and Sint Maarten
(`XCG`), Micronesia (`USD`), Bouvet Island (`NOK`), Heard Island and McDonald
Islands (`AUD`), and Zimbabwe (`ZWG`, replacing the obsolete `ZWB` entry).
Bulgaria uses `EUR`. Antarctica and South Georgia and the South Sandwich
Islands have no default currency, following SIX's no-universal-currency entries.
Palestine retains the source's associated currencies with `ILS` as the app default.

For entries with multiple currencies, defaults are the first retained source
currency except Saint Helena (`SHP`), Cook Islands (`NZD`), Western Sahara
(`MAD`), Palestine (`ILS`), and Zimbabwe (`ZWG`). Other associated currencies
are preserved when their codes appear in SIX's active list.

To update, retrieve both sources, review changes in country coverage and currency
associations, apply the transformations above, and update this provenance record.
Validate unique country codes, flag/code correspondence, active currency codes,
and membership of every non-null default in its entry's currency list.
Bundled data updates require an app release.
