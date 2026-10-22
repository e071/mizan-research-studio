# Mizan · Açık kaynak araştırma atölyesi

React arayüzü, beş akademik dizin, izlenebilir tekilleştirme/eleme kaydı, CSL tabanlı APA 7, gerçek DOCX ve BibTeX dışa aktarımı; bulutta Argos çevirisi ve Tesseract OCR.

## Bağımsız barındırma

Bu sürüm ChatGPT/Sites kimlik doğrulaması kullanmaz. Kullanıcının bilgisayarında sunucu veya dil modeli çalışmaz. `render.yaml` yalnız **Free** Docker web servisini tanımlar. Kart eklemeyin, ücretli plan veya disk oluşturmayın. Ücretsiz planın kota/kapasite sınırları dolduğunda bekleyin; ücretli yedeğe otomatik geçiş yoktur.

Render Free: 512 MB RAM, 0,1 CPU, 15 dakika boşta kalınca uyku. Başlangıç gecikmesi ve uzun OCR/çeviri süreleri mümkündür. 1 aktif ağır iş, en fazla 6 kuyruk işi. İş dosyaları geçicidir ve sunucu yeniden başlayınca kaybolur. Tamamlanan çeviriler ve araştırma kayıtları kullanıcının tarayıcısında saklanır; JSON yedeği alın.

## İşleme ve doğruluk

- Argos modelleri Docker **build** aşamasında indirilir; kaynak, sürüm ve SHA256 `/app/models/manifest.json` içinde tutulur. Dil paketleri: en→tr, de/fr/es→en→tr. CPU INT8, tek thread; OCR ve çeviri ayrı alt süreçlerde sırayla çalışır.
- PyMuPDF metin koordinatlarını okur; metinsiz sayfalarda Tesseract kaynak dilde OCR yapar. Taranmış harflerin görüntü pikselleri yalnız beyaz zeminli alanlarda kaldırılır. Renkli/karmaşık zemin, döndürülmüş metin ve sığmayan alanlar korunup raporlanır.
- Sayılar, atıflar ve terimce koruma kontrolünden geçer. Bu, anlamsal doğruluk garantisi değildir. Denklem, OCR, özel ad ve çok sütunlu sayfalar insan tarafından kontrol edilmelidir. Çevrilmeyen alanlar hiçbir zaman tamamlanmış gibi sunulmaz.
- OpenAlex/Crossref/Europe PMC/DOAJ/Semantic Scholar kapsamları farklıdır; ücretli ve indekslenmeyen literatürün tamamına erişim garanti edilemez. PRISMA sayıları çekilen kayıtlara ve kullanıcının eleme kararlarına dayanır.
- Deneysel sentez, ayrıca onayla Hugging Face üzerindeki açık Qwen servisine başlık/özet gönderir. Eşleşen kaynak alıntısı zorunludur; gönüllü servisin kapasitesi ve yorum doğruluğu garanti değildir. Taslak tamamlanmış sistematik/nitel makale diye etiketlenmez.

## Geliştirme ve test

`pnpm install --frozen-lockfile`, `pnpm typecheck`, `pnpm test`, `pnpm build`.
Docker imajı bulut CI üzerinde derlenir. `scripts/cloud-smoke.py` yerel yapay belgelerle gerçek OCR, çeviri, sayı koruması ve PDF çıktı kontrolü yapar. Model kullanıcı bilgisayarında çalıştırılmaz. GitHub Actions yalnız sınırlı derleme/test içindir; üretim sunucusu değildir.

## Kaynak ve lisans

Uygulama AGPL-3.0-or-later. Kaynak: https://github.com/e071/mizan-research-studio
PyMuPDF/MuPDF AGPL; Tesseract ve tessdata Apache-2.0; CTranslate2 MIT; SentencePiece Apache-2.0; Argos kodu/paketleri MIT/CC0 (upstream açıklaması: https://github.com/argosopentech/argos-translate/issues/533). Argos paketlerinin README ve metadata dosyaları imajda korunur. Noto Sans OFL; React MIT; citeproc-js CPAL/AGPL; docx MIT; CSL stil/lokal dosyalarının kendi lisans bildirimleri korunur. Ayrıntılar `public/licenses.html`.
