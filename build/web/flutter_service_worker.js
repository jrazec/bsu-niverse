'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "ca575584824e0e6039a5cd855b62710b",
"assets/AssetManifest.bin.json": "74cb2bfd4cc4aac7e08283a7ed0a994c",
"assets/AssetManifest.json": "b0f0b3f4fd6cf39eb6888f822f81d097",
"assets/assets/audio/background_music.mp3": "fe6eb7346e860e0e7aeb3d480037fdfa",
"assets/assets/audio/button_click.mp3": "4430dccb39fbb81011d87e3dde880814",
"assets/assets/audio/correct_answer.mp3": "c04f10add9a129f4293333c82c5116cf",
"assets/assets/audio/footstep.mp3": "d338ea728891147699657d0c6551eed5",
"assets/assets/audio/powerup_deactivate.mp3": "f0deac9278f501c923e14d148f2d00d9",
"assets/assets/audio/powerup_flicker.mp3": "bffc33b7e93a8e554cf9affd675fa491",
"assets/assets/audio/powerup_nolimits.mp3": "b6e75719899bbf4d3ee7d2cfe03cce94",
"assets/assets/audio/powerup_speed.mp3": "0545869e3619572b25523bd9e5cdc58d",
"assets/assets/audio/powerup_titan.mp3": "6e459b3c93e827370ae7199dcae5ccc0",
"assets/assets/audio/quest_complete.mp3": "704fd6412c0c605d0c410e3732d0dcfc",
"assets/assets/audio/quest_failed.mp3": "a7772cb33594f65ff2c8917576ebc5f6",
"assets/assets/audio/time_for_adventure.mp3": "c958b33ecc83cd7cccd1c5edaa52b11a",
"assets/assets/audio/wrong_answer.mp3": "ec2254712cbf1fdabb2ed30150182ca1",
"assets/assets/fonts/orange_kid.otf": "947228dc562bacde41fc48f0f8a8d0c5",
"assets/assets/fonts/pixeloid_sans/PixeloidSans-Bold.ttf": "9e6b48db6241c3c478656625f8b21514",
"assets/assets/fonts/pixeloid_sans/PixeloidSans.ttf": "2856e18113860d0ebdf66e2d9d728417",
"assets/assets/fonts/pixel_operator/PixelOperator-Bold.ttf": "612cfea7df335bc13533f2ee72737e13",
"assets/assets/fonts/SubFonts/Fira_Code/FiraCode-VariableFont_wght.ttf": "7b26f799cf1f7463429985c4e4e1949f",
"assets/assets/fonts/SubFonts/Press_Start_2P/PressStart2P-Regular.ttf": "f98cd910425bf727bd54ce767a9b6884",
"assets/assets/fonts/SubFonts/VT323/VT323-Regular.ttf": "034de38c65e202c1cc838e7d014385fd",
"assets/assets/images/assoc.caringal-drawing.png": "874c01803c22aa06ecf1731d3cdf46e4",
"assets/assets/images/atty-drawing.png": "9e6523aa1d507f5c3bb9cc8f65b0e527",
"assets/assets/images/bad.jpeg": "a246543f36a20d4f616342e9eb1f00b7",
"assets/assets/images/bedroom.png": "f24f4f959e6cf9f632b59e27a2375206",
"assets/assets/images/berna.png": "000a3dfc322fa12595c65809ccb95adb",
"assets/assets/images/boy_jpcs.png": "de458285acc4407c48f3474f2101230a",
"assets/assets/images/boy_pe.png": "f58a8b6a8e6a728fb0494a0a97554cbb",
"assets/assets/images/boy_techis.png": "a7baac10e6cb05edbe35ef260b620167",
"assets/assets/images/boy_uniform.png": "2d084985af643cc4f18449451b740b4c",
"assets/assets/images/bsuniverse_logo.png": "6a765a31b1c69271df6f228085342adb",
"assets/assets/images/bsu_lipa.png": "a1a58aafa6d10fbc0c69bdc12c7f28bb",
"assets/assets/images/canteenldc.png": "db915aa2feaa08f3f26e8c58cff8dff2",
"assets/assets/images/card_texture.png": "d3366696287012afed555d291962d4e2",
"assets/assets/images/caspur.png": "9207288365984ef832b75da76722dffc",
"assets/assets/images/cics.png": "7bfb46e125e6ab23129017034c66ab71",
"assets/assets/images/classroom%2520cecs-heb.png": "2c5033381dc4e3f9e2b39a013d94a2a0",
"assets/assets/images/classroom-ldc.png": "d5b56ee08f63982ec7eefad66c06e1e0",
"assets/assets/images/classroom-ob.png": "240712298ba4669e5035f7fdd418dccc",
"assets/assets/images/closet.jpg": "1811cfe8f0d9a8179e8ded79ed82cb54",
"assets/assets/images/closet.png": "a5c763eb9a99b533e06e1e8f6982741c",
"assets/assets/images/comlab-cecs.png": "2a0814558b520fc45181124734f9debc",
"assets/assets/images/comlab-cecs2.png": "29a57794922d3445d0659d87823f1d09",
"assets/assets/images/comlabheb.png": "70ea300fa0b4e2597fcdf4687eba5dc6",
"assets/assets/images/courtss.png": "5b450464883f7a5fc1384c991975c239",
"assets/assets/images/dr.amorado-drawing.png": "bd4b0224f9388771c8e6c3ef284c482f",
"assets/assets/images/dr.balazon-drawing.png": "050e2ad281872a499dcdbbf4c448e91c",
"assets/assets/images/dr.castillo-drawing.png": "8a51b3b8336040e448b74aa29af279b3",
"assets/assets/images/dr.generoso-drawing.png": "48fb856bb851b80972de2816f808f4bd",
"assets/assets/images/dr.godoy-drawing.png": "2bad79dc29483bac7b9b517fa433214e",
"assets/assets/images/dr.magundayao-drawing.png": "6260f630257a4eb93a196d22586ae7bc",
"assets/assets/images/dr.malaluan-drawing.png": "32d570a3f50e0bc25d040eb5e6b28dd2",
"assets/assets/images/dr.soquiat-drawing.png": "6260f630257a4eb93a196d22586ae7bc",
"assets/assets/images/engr.melo-drawing.png": "f1f2ad90c5e31ab1cd8de28c396a0ba5",
"assets/assets/images/facade.png": "bb7f10b2dd9969309e38f11223fbef11",
"assets/assets/images/girl_jpcs.png": "53009527129bf68d4db0a560516d6cde",
"assets/assets/images/girl_pe.png": "70afb07e075fda72e27474bd709c3574",
"assets/assets/images/girl_techis.png": "10120e0dba474e3f1a603a2f75f64630",
"assets/assets/images/girl_uniform.png": "f9ce366df465b0eb7cc46364888c2b4f",
"assets/assets/images/hallway-tileset.png": "a47f87c8253ff67c506ae9676ccf595b",
"assets/assets/images/joyb8.png": "0a8df7e892531ebb5b33893648280791",
"assets/assets/images/joystickCenter.png": "572776cda1d937bad57e144ba921b346",
"assets/assets/images/joyv1.png": "47c0813ec5bce6d92bee21fbb358cd69",
"assets/assets/images/joyv2.png": "7d053cb4af1c37f8cfa57b81f186f861",
"assets/assets/images/joyv3.png": "316d6164723b6a10691de35a20c59887",
"assets/assets/images/joyv4.png": "9e74749d7d1da4b5df17f829940c5760",
"assets/assets/images/joyv5.png": "0f5b3d2f399cb9022dc2493d57f71b47",
"assets/assets/images/joyv6.png": "713540522fc8118a3f78755cf42f0591",
"assets/assets/images/joyv7.png": "5eeeee8362e62291888bba0fd657a7fe",
"assets/assets/images/joyv8.png": "4fb5eca8924a09765a71a21c8d1027a9",
"assets/assets/images/joyv9.png": "68bf4d91b9781ebb3eb9714bf5153e71",
"assets/assets/images/jpcs_set.png": "aea98dd62f6a9c3f4c77ead648d514ef",
"assets/assets/images/kimplerx.png": "a008fdfd1d9cef2d969a5c80ae0045a7",
"assets/assets/images/kimplerx2.png": "43e062dd6cec698ef05d7691f49a35b3",
"assets/assets/images/libr.png": "c088c8caf5c7efa1a3af84db974ab3b7",
"assets/assets/images/map-tileset.png": "78cf9b2fb845b524af00ca4d8d815b07",
"assets/assets/images/mappreview.png": "55e55f47a77ad9f95e1a5691854dc19d",
"assets/assets/images/men_school_unif.png": "b4ef4cc289cab070cf9987a321983985",
"assets/assets/images/mr.alimoren-drawing%2520(1).png": "c0da14d7788d0a035ddb71a1e8d6f04f",
"assets/assets/images/mrs.balita-drawing.png": "066cdbabfe219f4894eda657975643fb",
"assets/assets/images/ms.lumbera-drawing.png": "b215e25ae361d18370b47ba30521aca8",
"assets/assets/images/ms.sulit-drawing%2520(1).png": "024596cb91092c80d8d18ca4ff9b7283",
"assets/assets/images/multimedia.png": "5578a46bb7e9e0b1225a0a7abf604ffa",
"assets/assets/images/overlay.png": "0f2cc97b1616ee8547d5ba7fc93f92c2",
"assets/assets/images/pe_uniform.png": "bd374f78b8bf6427488b33ed2c6ec404",
"assets/assets/images/pokebol.png": "da11c580f2d2f684cf7f450b3479f899",
"assets/assets/images/puge.png": "629f8358e1561d771d492be2ce47b85c",
"assets/assets/images/razec.png": "31306cb2aaaca630528024a8a98b42b0",
"assets/assets/images/run.png": "41deda79994866bb814eafa42aabbf5b",
"assets/assets/images/sirt.png": "6ad447cc33116833a132beea5d55cd87",
"assets/assets/images/tech_is_set.png": "8559d9fced3d6dff0a686352313a03fa",
"assets/assets/images/titan.png": "dbf980673957b4826260d14301751680",
"assets/assets/images/usok.png": "6f27234f6627795313e1dcf076c802b2",
"assets/assets/images/women_school_unif.png": "fd1985b30bc90f8527d01e96a5aad2d8",
"assets/assets/images/yajie.png": "8234df169170f47d1b106e621f772587",
"assets/assets/images/yey.gif": "c5a564023e6a9f684e12f84a287de487",
"assets/assets/images/yey.png": "add4622e38a9b0fdaddc4f341a67d69a",
"assets/assets/images/yuhh.png": "27212268b38ed1612bed2527a0feea10",
"assets/assets/tiles/Bedroom.tmx": "0118d20c8c72f8c69b6b65e6b89e6c38",
"assets/assets/tiles/bsu-map.tmx": "72f05f00ea3a7df3c161fdd0375521c8",
"assets/assets/tiles/canteenldc.tmx": "c714d2a9f1741e2ee503f6a3a9533ac4",
"assets/assets/tiles/canteenldc.tsx": "76d3c644adf41f7208203fb40bee0cec",
"assets/assets/tiles/cecs.tmx": "0691276e053d221480cba488476f6396",
"assets/assets/tiles/cecsClassroom.tsx": "f11444074326c7c6c30470737ba15b02",
"assets/assets/tiles/classroom-ldc.tmx": "57d257237439db6e182f0feb25a0cef2",
"assets/assets/tiles/classroom-ldc.tsx": "9408d0fdcc4342fcd516715e4022b8cf",
"assets/assets/tiles/classroom-ob.tmx": "acf29e36a4a819a8b7f0d3d7a0c51622",
"assets/assets/tiles/classroom-ob.tsx": "a4fbe22000a3cdc46945ec6a4ff91455",
"assets/assets/tiles/classroom_cecs-heb.tmx": "5052758bd2ae4ba07a2097dea0f950e2",
"assets/assets/tiles/comlab-cecs.tsx": "0ad1461eb94b91a65c55deb0fc4523ad",
"assets/assets/tiles/comlab-cecs2.tsx": "cbeb89b5384e0671caf9c11847c3e03b",
"assets/assets/tiles/Comlab502_cecs.tmx": "5ff1a5416de54ca46ddd0ef4d5c9e7d1",
"assets/assets/tiles/Comlab503_cecs.tmx": "da85aa7c195e2ce35daa102e0f5901b6",
"assets/assets/tiles/ComlabHeb.tmx": "3dc784a9ac4afa652e165a10ee074032",
"assets/assets/tiles/comlabheb.tsx": "dbdfc2e427dbd657c00b343251019b4e",
"assets/assets/tiles/courtss.tsx": "a9a7639e54af2f5293572b1de695eef4",
"assets/assets/tiles/facade.tmx": "31a80fdad06eef6aabd40f9c0aeb1784",
"assets/assets/tiles/facade.tsx": "6f23ae450718c774244bc2efcfb8d4f9",
"assets/assets/tiles/Gym.tmx": "9d4206dcbe52da2ea633456e1cae2e2f",
"assets/assets/tiles/gzbuilding.tmx": "11b8dbe2ae07d1937a7c571ef552e437",
"assets/assets/tiles/hallway.tsx": "d209417325342427a4fb91d8fbeea1af",
"assets/assets/tiles/hebuilding.tmx": "3b518afbb4a85d6fd72287308362699c",
"assets/assets/tiles/LDC.tmx": "89f14e5a588fa244b12e0906b86c4448",
"assets/assets/tiles/libr.tsx": "53e7a13cbe42870cf221bebd033911db",
"assets/assets/tiles/Library.tmx": "c5cdc9fc186eeb632a0537c2f6e4b798",
"assets/assets/tiles/map.tsx": "d57e532831f7e594dc206d3c20eeb64b",
"assets/assets/tiles/multimedia.tmx": "db1bb29f241ecab94174dd481865a559",
"assets/assets/tiles/multimedia.tsx": "db61d7bdea4c46126414aff0d99218ed",
"assets/assets/tiles/old_building.tmx": "42a1ab133d248369294878719b29d717",
"assets/assets/tiles/test.tsx": "ed4c50a6064efeef26010d6cbff4ee49",
"assets/FontManifest.json": "14504d1781e8e96c1c07ddb7a4a0ffd3",
"assets/fonts/MaterialIcons-Regular.otf": "d43ed4e45606d52207f73aafe9279de1",
"assets/NOTICES": "e4d7b55dcbee4876d9698cecdab7a359",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"flutter_bootstrap.js": "58b7a247804f6e246ac3cae67ee6d278",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "c0233a420d219b73d58570912bccb75e",
"/": "c0233a420d219b73d58570912bccb75e",
"main.dart.js": "abda7840ba644045089b06f0a3062186",
"manifest.json": "b56c2799788ccf007bc4e97e04705459",
"version.json": "bff055a2946a46296c9f1bf3066585a3"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
