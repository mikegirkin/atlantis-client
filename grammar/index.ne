@{%
  const noop = () => null;

  const filterEmpty = (d) => {
    return d.filter((val) => {
      if (val == null) {
        return false;
      }
      if (Array.isArray(val) && val.length === 0) {
        return false;
      }
      return true;
    });
  }

  const array2String = (d) => {
    if (!Array.isArray(d)) {
      return d;
    }
    return d.reduce((result, val) => {
      if (Array.isArray(val)) {
        val = array2String(val);
      }
      if (val == null) {
        val = "";
      }
      result += val;
      return result;
    }, "");
  }

  const factionProcessor = (d, i, reject) => {
    const faction = {
      type: "FACTION_INFO",
      factionName: d[0],
      factionNumber: d[3],
      points: {
        war: 0,
        trade: 0,
        magic: 0
      }
    };

    if (d[6]) {
      faction.points.war = d[6].war || 0,
      faction.points.trade = d[6].trade || 0
      faction.points.magic = d[6].magic || 0
    }
    return faction;
  }

  const dateProcessor = (d, i, reject) => {
    return {
      type: "DATE",
      month: d[0],
      day: d[5]
    };
  }

  const versionProcessor = (d) => {
    return {
      atlantisVersion: d[2],
      engineName: d[4],
      engineVersion: d[9]
    };
  };

  const factionStatusProcessor = (d) => {
    if (!Array.isArray(d[2])) {
      return null;
    }

    return d[2].reduce((result, val) => {
      if (val == null) {
        return result;
      }
      return Object.assign({}, result, val[0]);
    }, {type: "FACTION_STATUS"});
  };

  const errorsProcessor = (d) => {
    if (!Array.isArray(d[2])) {
      return null;
    }
    return {
      type: "ERRORS",
      errors: d[2]
    };
  }
%}

REPORT_PARSER ->
  START
  REPORT_FACTION
  REPORT_DATE
  ATL_VERSION
  FACTION_STATUS
  FACTION_ERRORS:?
  #FACTION_BATTLES
  FACTION_EVENTS:?
  # SENTENCE_
  {% filterEmpty %}

# ------------------------------------------------------------
# HEADER INFO
# ------------------------------------------------------------

START ->
  "Atlantis Report For:" NL_ {% noop %}

REPORT_FACTION ->
  TEXT _ "(" INT ")" _ "(" TEXT ")" NL_

REPORT_DATE ->
  TEXT "," _ "Year" _ INT NL_

ATL_VERSION ->
  "Atlantis Engine Version:" _ VERSION NL
  TEXT ", Version:" _ VERSION NL_

VERSION ->
  INT | INT "." VERSION

FACTION_STATUS ->
  "Faction Status:" NL
  FACTION_STATUS_DETAILS:+
  NL_

FACTION_STATUS_DETAILS ->
  "Tax Regions:" _ INT _ "(" INT ")" NL
  | "Trade Regions:" _ INT _ "(" INT ")" NL
  | "Mages:" _ INT _ "(" INT ")" NL
  | "Apprentices:" _ INT _ "(" INT ")" NL

# ------------------------------------------------------------
# FACTION ERRORS
# ------------------------------------------------------------
FACTION_ERRORS ->
  "Errors during turn:"
  NL
  FACTION_ERRORS_ITEMS
  NL_

FACTION_ERRORS_ITEMS ->
  SENTENCE_

# ------------------------------------------------------------
# FACTION BATTLES
# ------------------------------------------------------------
#FACTION_BATTLES ->


# ------------------------------------------------------------
# FACTION EVENTS
# ------------------------------------------------------------
FACTION_EVENTS ->
  "Events during turn:"
  NL
  FACTION_EVENTS_ITEMS
  NL_

FACTION_EVENTS_ITEMS ->
  SENTENCE_

# ------------------------------------------------------------
# HELPER RULES
# ------------------------------------------------------------

NL ->
  [\n] {% noop %}

NL_ ->
  NL:+

INT ->
  [0-9]:+ {% (d) => parseInt(d[0].join("")) %}

_ ->
  [ ] {% id %}

__ ->
  _:+ {% id %}

SENTENCE ->
  WORD [.!]
  | WORD __ SENTENCE {% array2String %}
  | WORD NL __ SENTENCE {% array2String %}

SENTENCE_ ->
  (SENTENCE NL_):+

TEXT ->
  WORD
  | WORD __ TEXT {% array2String %}
  | WORD NL __ TEXT {% array2String %}

WORD ->
  [^\n\r ]:+ {% array2String %}