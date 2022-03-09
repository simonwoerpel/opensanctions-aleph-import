drop table if exists ftm_ru_recent_sanctions_2022;

/* sanction entities */
create table ftm_ru_recent_sanctions_2022 as (
  select
    s.*
  from ftm_opensanctions s
  join ftm_opensanctions e on
    s.entity @> '{"schema": "Sanction"}' and
    e.entity -> 'properties' -> 'country' @> '"ru"' and
    s.entity -> 'properties' -> 'listingDate' ->> 0 > '2022-02-21' and
    s.entity -> 'properties' -> 'entity' ->> 0 = e.id
);

/* target entities */
insert into ftm_ru_recent_sanctions_2022 (
  select
    e.*
  from ftm_opensanctions s
  join ftm_opensanctions e on
    s.entity @> '{"schema": "Sanction"}' and
    e.entity -> 'properties' -> 'country' @> '"ru"' and
    s.entity -> 'properties' -> 'listingDate' ->> 0 > '2022-02-21' and
    s.entity -> 'properties' -> 'entity' ->> 0 = e.id
);
