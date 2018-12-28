## MultiSync API Client for https://source.unsplash.com
import asyncdispatch, httpclient, strutils

const unsplashApiUrl* = "https://source.unsplash.com/" ## Unsplash API URL (SSL)

type
  UnsplashBase*[HttpType] = object ## Base object.
    timeout*: byte  ## Timeout Seconds for API Calls, byte type, 0~255.
    proxy*: Proxy  ## Network IPv4 / IPv6 Proxy support, Proxy type.
  Unsplash* = UnsplashBase[HttpClient]           ##  Sync Unsplash API Client.
  AsyncUnsplash* = UnsplashBase[AsyncHttpClient] ## Async Unsplash API Client.

template clientify(this: Unsplash | AsyncUnsplash): untyped =
  ## Build & inject basic HTTP Client with Proxy and Timeout.
  var client {.inject.} =
    when this is AsyncUnsplash: newAsyncHttpClient(
      proxy = when declared(this.proxy): this.proxy else: nil, userAgent="")
    else: newHttpClient(
      timeout = when declared(this.timeout): this.timeout.int * 1_000 else: -1,
      proxy = when declared(this.proxy): this.proxy else: nil, userAgent="")

proc random*(this: Unsplash | AsyncUnsplash, width, height: int16): Future[string] {.multisync.} =
  ## Return a Random photo from a random user on unsplash.
  clientify(this)
  let url = unsplashApiUrl & "random/" & $width & "x" & $height
  result =
    when this is AsyncUnsplash: await client.getContent(url=url)
    else: client.getContent(url=url)

proc randomFromUser*(this: Unsplash | AsyncUnsplash, user: string, width, height: int16): Future[string] {.multisync.} =
  ## Return a Random photo from a specific user on unsplash.
  clientify(this)
  let url = unsplashApiUrl & "user/" & user & "/" & $width & "x" & $height
  result =
    when this is AsyncUnsplash: await client.getContent(url=url)
    else: client.getContent(url=url)

proc likesFromUser*(this: Unsplash | AsyncUnsplash, user: string, width, height: int16): Future[string] {.multisync.} =
  ## Return a Liked photo from a specific user on unsplash.
  clientify(this)
  let url = unsplashApiUrl & "user/" & user & "/likes/" & $width & "x" & $height
  result =
    when this is AsyncUnsplash: await client.getContent(url=url)
    else: client.getContent(url=url)

proc randomFromCollection*(this: Unsplash | AsyncUnsplash, collectionId: int, width, height: int16): Future[string] {.multisync.} =
  ## Return a Random photo from a specific Collection on unsplash.
  clientify(this)
  let url = unsplashApiUrl & "collection/" & $collectionId & "/" & $width & "x" & $height
  result =
    when this is AsyncUnsplash: await client.getContent(url=url)
    else: client.getContent(url=url)

proc dailyFromUser*(this: Unsplash | AsyncUnsplash, user: string, search: seq[string], width, height: int16): Future[string] {.multisync.} =
  ## Return a Daily photo from a specific user on unsplash.
  clientify(this)
  let url = unsplashApiUrl & "user/" & user & "/daily/" & $width & "x" & $height & "?" & search.join(",")
  result =
    when this is AsyncUnsplash: await client.getContent(url=url)
    else: client.getContent(url=url)

proc weeklyFromUser*(this: Unsplash | AsyncUnsplash, user: string, search: seq[string], width, height: int16): Future[string] {.multisync.} =
  ## Return a Weekly photo from a specific user on unsplash.
  clientify(this)
  let url = unsplashApiUrl & "user/" & user & "/weekly/" & $width & "x" & $height & "?" & search.join(",")
  result =
    when this is AsyncUnsplash: await client.getContent(url=url)
    else: client.getContent(url=url)

proc dailyRandom*(this: Unsplash | AsyncUnsplash, search: seq[string], width, height: int16): Future[string] {.multisync.} =
  ## Return a Daily Random photo from unsplash.
  clientify(this)
  let url = unsplashApiUrl & "daily/" & $width & "x" & $height & "?" & search.join(",")
  result =
    when this is AsyncUnsplash: await client.getContent(url=url)
    else: client.getContent(url=url)

proc weeklyRandom*(this: Unsplash | AsyncUnsplash, search: seq[string], width, height: int16): Future[string] {.multisync.} =
  ## Return a Weekly Random photo from unsplash.
  clientify(this)
  let url = unsplashApiUrl & "weekly/" & $width & "x" & $height & "?" & search.join(",")
  result =
    when this is AsyncUnsplash: await client.getContent(url=url)
    else: client.getContent(url=url)

proc featuredRandom*(this: Unsplash | AsyncUnsplash, search: seq[string], width, height: int16): Future[string] {.multisync.} =
  ## Return a Featured Curated Random photo from unsplash.
  clientify(this)
  let url = unsplashApiUrl & "featured/" & $width & "x" & $height & "?" & search.join(",")
  result =
    when this is AsyncUnsplash: await client.getContent(url=url)
    else: client.getContent(url=url)

proc getPhoto*(this: Unsplash | AsyncUnsplash, photoId: string, width, height: int16): Future[string] {.multisync.} =
  ## Return a specific photo from a specific user on unsplash.
  clientify(this)
  let url = unsplashApiUrl & "/" & photoId & "/" & $width & "x" & $height
  result =
    when this is AsyncUnsplash: await client.getContent(url=url)
    else: client.getContent(url=url)


when isMainModule and not defined(release):
  let cliente = Unsplash(timeout: 99)
  echo cliente.random(800, 600)
  echo cliente.randomFromUser("juancarlospaco", 800, 600)
  echo cliente.likesFromUser("juancarlospaco", 800, 600)
  echo cliente.randomFromCollection(139386, 800, 600)
  echo cliente.dailyFromUser("juancarlospaco", @["cats", "girls"], 800, 600)
  echo cliente.weeklyFromUser("juancarlospaco", @["cats", "girls"], 800, 600)
  echo cliente.dailyRandom(@["cats", "girls"], 800, 600)
  echo cliente.weeklyRandom(@["cats", "girls"], 800, 600)
  echo cliente.featuredRandom(@["cats", "girls"], 800, 600)
  echo cliente.getPhoto("DfKZs6DOrw4", 800, 600)
