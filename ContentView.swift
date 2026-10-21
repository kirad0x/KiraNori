import SwiftUI

// MARK: - 1. ANA UYGULAMA GİRİŞİ VE DİNAMİK ARKA PLAN
struct ContentView: View {
    @State private var isJailbroken: Bool = false
    @State private var showModeSelector: Bool = true
    @State private var currentWallpaper: String = "wallpaper_default"
    @State private var wallpaperBrightness: Double = 0.5
    @State private var selectedTab: Int = 0

    var body: some View {
        ZStack {
            // Dinamik Aydınlatmalı Arka Plan Görseli
            Image(currentWallpaper)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .brightness(wallpaperBrightness - 0.5)
                .overlay(Color.black.opacity(0.35))

            if showModeSelector {
                // Açılış Mod Seçim Ekranı (iOS Cam Efektli Card)
                VStack(spacing: 22) {
                    Text("KiraNori")
                        .font(.system(size: 44, weight: .black, design: .rounded))
                        .foregroundColor(.pink)
                        .shadow(color: .pink.opacity(0.8), radius: 15)

                    Text("Gelişmiş iOS Sistem & Emülasyon Suite")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white.opacity(0.9))

                    VStack(spacing: 14) {
                        GlassButton(title: "Jailbreak Modu (Root Yetkisi)", icon: "lock.open.fill", color: .purple) {
                            isJailbroken = true
                            showModeSelector = false
                        }

                        GlassButton(title: "Jailbreaksiz Mod (Sandbox)", icon: "lock.fill", color: .pink) {
                            isJailbroken = false
                            showModeSelector = false
                        }
                    }
                    .padding(.horizontal, 5)

                    // Credits Bölümü
                    VStack(spacing: 6) {
                        Text("CREDITS")
                            .font(.caption2)
                            .bold()
                            .foregroundColor(.white.opacity(0.6))

                        HStack(spacing: 15) {
                            Text("GitHub: @kirad0x").font(.caption).bold().foregroundColor(.cyan)
                            Text("TikTok: @hello.imkira").font(.caption).bold().foregroundColor(.pink)
                        }
                    }
                    .padding(.top, 10)
                }
                .padding(25)
                .background(.ultraThinMaterial)
                .cornerRadius(32)
                .overlay(
                    RoundedRectangle(cornerRadius: 32)
                        .stroke(Color.white.opacity(0.25), lineWidth: 1.5)
                )
                .shadow(color: Color.black.opacity(0.5), radius: 25, x: 0, y: 15)
                .padding(20)
                .onAppear { loadRandomWallpaper() }
            } else {
                // Ana Navigasyon (Tab Bar)
                TabView(selection: $selectedTab) {
                    WindowsEmulatorView()
                        .tabItem { Label("Win Engine", systemImage: "desktopcomputer") }
                        .tag(0)

                    FileManagerView(isJailbroken: isJailbroken)
                        .tabItem { Label("Dosyalar", systemImage: "folder.fill") }
                        .tag(1)

                    TerminalView(isJailbroken: isJailbroken)
                        .tabItem { Label("Terminal", systemImage: "terminal.fill") }
                        .tag(2)

                    DownloaderView()
                        .tabItem { Label("İndirici", systemImage: "square.and.arrow.down.fill") }
                        .tag(3)

                    MiniGamesView()
                        .tabItem { Label("Arcade", systemImage: "gamecontroller.fill") }
                        .tag(4)

                    SettingsView(wallpaperBrightness: $wallpaperBrightness, currentWallpaper: $currentWallpaper, showModeSelector: $showModeSelector)
                        .tabItem { Label("Ayarlar", systemImage: "gearshape.fill") }
                        .tag(5)
                }
                .accentColor(.pink)
            }
        }
    }

    func loadRandomWallpaper() {
        let wallpapers = ["bg1", "bg2", "bg3", "bg4", "wallpaper_default"]
        currentWallpaper = wallpapers.randomElement() ?? "wallpaper_default"
    }
}

// MARK: - 2. CAM EFEKTLİ (LIQUID GLASS) YUMUŞATILMIŞ BUTON
struct GlassButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                Text(title)
                    .fontWeight(.semibold)
                Spacer()
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 18)
            .foregroundColor(.white)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(color.opacity(0.55))
                    .background(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )
            .shadow(color: color.opacity(0.45), radius: 12, x: 0, y: 6)
        }
    }
}

// MARK: - 3. WINDOWS EMÜLATÖR & DOKUNMATİK JOYSTICK MODÜLÜ
struct WindowsEmulatorView: View {
    @State private var isFullScreen: Bool = false
    @State private var showJoystick: Bool = false
    @State private var isRunning: Bool = false
    @State private var isoUrl: String = ""

    var body: some View {
        VStack(spacing: 15) {
            // Kontrol Barı
            HStack {
                Text("KiraNori WinEngine")
                    .font(.headline)
                    .foregroundColor(.pink)

                Spacer()

                // Tam Ekran Aç/Kapa
                Button(action: { isFullScreen.toggle() }) {
                    Image(systemName: isFullScreen ? "arrow.down.right.and.arrow.up.left" : "arrow.up.left.and.arrow.down.right")
                        .foregroundColor(.white)
                        .padding(10)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                }

                // Joystick Göster/Gizle
                Button(action: { showJoystick.toggle() }) {
                    Image(systemName: "gamecontroller.fill")
                        .foregroundColor(showJoystick ? .green : .white)
                        .padding(10)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal)

            if !isFullScreen {
                TextField("ISO veya Disk İmaj Linki Girin...", text: $isoUrl)
                    .padding(12)
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
                    .foregroundColor(.white)
                    .padding(.horizontal)
            }

            // Windows Ekranı ve Sanal Joystick Katmanı
            ZStack {
                RoundedRectangle(cornerRadius: isFullScreen ? 0 : 24, style: .continuous)
                    .fill(Color.black)
                    .frame(height: isFullScreen ? nil : 320)
                    .overlay(
                        VStack {
                            if isRunning {
                                VStack {
                                    Image(systemName: "desktopcomputer")
                                        .font(.system(size: 60))
                                        .foregroundColor(.cyan)
                                    Text("Windows Sanal Makine Çalışıyor\n(JIT Aktif)")
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.white)
                                        .bold()
                                }
                            } else {
                                Text("Windows Kapalı\n'Başlat' Butonuna Basın")
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.gray)
                            }
                        }
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: isFullScreen ? 0 : 24)
                            .stroke(Color.white.opacity(0.15), lineWidth: 1)
                    )

                // Dokunmatik Sanal Oyun Butonları
                if showJoystick && isRunning {
                    VStack {
                        Spacer()
                        HStack {
                            // Sol Analog Joystick
                            Circle()
                                .fill(Color.white.opacity(0.2))
                                .frame(width: 90, height: 90)
                                .overlay(Circle().fill(Color.pink.opacity(0.7)).frame(width: 42, height: 42))
                                .padding(.leading, 20)

                            Spacer()

                            // Sağ Oyun Butonları (A, B, X, Y)
                            VStack(spacing: 8) {
                                HStack(spacing: 12) {
                                    GameButton(label: "Y", color: .yellow)
                                }
                                HStack(spacing: 18) {
                                    GameButton(label: "X", color: .blue)
                                    GameButton(label: "B", color: .red)
                                }
                                HStack(spacing: 12) {
                                    GameButton(label: "A", color: .green)
                                }
                            }
                            .padding(.trailing, 20)
                        }
                        .padding(.bottom, 25)
                    }
                }
            }

            if !isFullScreen {
                GlassButton(
                    title: isRunning ? "Windows'u Kapat" : "Windows'u Başlat (UTM Engine)",
                    icon: "power",
                    color: isRunning ? .red : .pink
                ) {
                    isRunning.toggle()
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
    }
}

struct GameButton: View {
    let label: String
    let color: Color

    var body: some View {
        Circle()
            .fill(color.opacity(0.85))
            .frame(width: 38, height: 38)
            .overlay(Text(label).bold().foregroundColor(.white))
            .shadow(color: color.opacity(0.5), radius: 6)
    }
}

// MARK: - 4. DOSYA YÖNETİCİSİ MODÜLÜ (JAILBREAK / SANDBOX UYUMLU)
struct FileManagerView: View {
    let isJailbroken: Bool
    @State private var currentPath: String = ""
    @State private var files: [String] = []

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Dosya Yöneticisi")
                    .font(.title2).bold()
                    .foregroundColor(.pink)
                Spacer()
                Text(isJailbroken ? "Root / Kök" : "Sandbox")
                    .font(.caption).bold()
                    .padding(.vertical, 4)
                    .padding(.horizontal, 10)
                    .background(isJailbroken ? Color.purple : Color.gray)
                    .cornerRadius(10)
                    .foregroundColor(.white)
            }

            Text("Dizin: \(currentPath)")
                .font(.caption)
                .foregroundColor(.gray)

            List {
                ForEach(files, id: \.self) { file in
                    HStack {
                        Image(systemName: file.contains(".") ? "doc.fill" : "folder.fill")
                            .foregroundColor(file.contains(".") ? .cyan : .yellow)
                        Text(file)
                            .foregroundColor(.white)
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .listStyle(PlainListStyle())
            .background(.ultraThinMaterial)
            .cornerRadius(20)
        }
        .padding()
        .onAppear { loadDirectory() }
    }

    func loadDirectory() {
        if isJailbroken {
            currentPath = "/"
            files = ["var", "System", "Library", "Applications", "private", "usr", "bin"]
        } else {
            currentPath = "/Documents"
            files = ["Wallpapers", "Downloads", "ISO_Images", "Config.json"]
        }
    }
}

// MARK: - 5. KİRANORİ ANİME MIKU TERMINAL MODÜLÜ
struct TerminalView: View {
    let isJailbroken: Bool
    @State private var inputCommand: String = ""
    @State private var logs: [String] = ["KiraNori OS v2.6 Terminal Başlatıldı.", "MikuShell v1.0 hazır. Komut yazın (örn: help, sysinfo, neofetch)"]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("KiraNori Terminal")
                .font(.title2).bold()
                .foregroundColor(.pink)

            ScrollView {
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(logs, id: \.self) { log in
                        Text(log)
                            .font(.system(.caption, design: .monospaced))
                            .foregroundColor(.green)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .frame(maxHeight: .infinity)
            .background(Color.black.opacity(0.85))
            .cornerRadius(20)
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.green.opacity(0.4), lineWidth: 1))

            HStack {
                Text(">").foregroundColor(.green).bold()
                TextField("Komut girin...", text: $inputCommand)
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.white)
                    .onSubmit { runCommand() }

                Button("Gönder") { runCommand() }
                    .foregroundColor(.pink)
            }
            .padding(12)
            .background(.ultraThinMaterial)
            .cornerRadius(16)
        }
        .padding()
    }

    func runCommand() {
        guard !inputCommand.isEmpty else { return }
        let cmd = inputCommand.lowercased().trimmingCharacters(in: .whitespaces)
        logs.append("miku@kiranori:~$ \(inputCommand)")

        switch cmd {
        case "help":
            logs.append("Mevcut Komutlar: help, sysinfo, neofetch, clear, jitsatus")
        case "neofetch", "sysinfo":
            logs.append("OS: KiraNori OS 2.6")
            logs.append("Kernel: Darwin iOS")
            logs.append("Mod: \(isJailbroken ? "Jailbroken (Root)" : "Sandbox")")
        case "clear":
            logs.removeAll()
        case "jitstatus":
            logs.append("JIT Servisi: Aktif (QEMU Sanallaştırma Hazır)")
        default:
            logs.append("Bilinmeyen komut: \(cmd)")
        }
        inputCommand = ""
    }
}

// MARK: - 6. AKILLI LİNK İNDİRİCİ & YÜKLEME TERCİHİ MODÜLÜ
struct DownloaderView: View {
    @State private var downloadLink: String = ""
    @State private var downloadProgress: Double = 0.0
    @State private var isDownloading: Bool = false
    @State private var showAlert: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Paket & IPA İndirici")
                .font(.title2).bold()
                .foregroundColor(.pink)

            TextField("Dosya/IPA İndirme Bağlantısı...", text: $downloadLink)
                .padding(14)
                .background(.ultraThinMaterial)
                .cornerRadius(18)
                .foregroundColor(.white)

            GlassButton(title: "İndir ve İşle", icon: "arrow.down.circle.fill", color: .blue) {
                startDownload()
            }

            if isDownloading {
                ProgressView("İndiriliyor...", value: downloadProgress, total: 100.0)
                    .accentColor(.pink)
                    .foregroundColor(.white)
                    .padding()
            }

            Spacer()
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("İndirme Tamamlandı!"),
                message: Text("İndirilen paket cihazınıza yüklensin mi (install)?"),
                primaryButton: .default(Text("Evet, Yükle")) {
                    // Cihaza yükleme akışı
                },
                secondaryButton: .cancel(Text("Hayır, Sadece Sakla"))
            )
        }
    }

    func startDownload() {
        isDownloading = true
        downloadProgress = 0.0
        Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { timer in
            downloadProgress += 20.0
            if downloadProgress >= 100.0 {
                timer.invalidate()
                isDownloading = false
                showAlert = true
            }
        }
    }
}

// MARK: - 7. MINI MIKU ARCADE (EĞLENCE OYUNLARI)
struct MiniGamesView: View {
    @State private var score: Int = 0
    @State private var timerCount: Int = 10
    @State private var isGameActive: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            Text("KiraNori Arcade")
                .font(.title2).bold()
                .foregroundColor(.pink)

            VStack(spacing: 16) {
                Text("Anime Reflex Tapper")
                    .font(.headline)
                    .foregroundColor(.white)

                Text("Skor: \(score)")
                    .font(.system(size: 38, weight: .black, design: .rounded))
                    .foregroundColor(.yellow)

                Text("Kalan Süre: \(timerCount)s")
                    .foregroundColor(.gray)

                Button(action: {
                    if isGameActive {
                        score += 1
                    } else {
                        startGame()
                    }
                }) {
                    Circle()
                        .fill(isGameActive ? Color.pink : Color.purple)
                        .frame(width: 120, height: 120)
                        .overlay(
                            Text(isGameActive ? "TIKLA!" : "BAŞLAT")
                                .font(.title3).bold()
                                .foregroundColor(.white)
                        )
                        .shadow(color: .pink.opacity(0.6), radius: 15)
                }
            }
            .padding(30)
            .background(.ultraThinMaterial)
            .cornerRadius(30)
            .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.white.opacity(0.2), lineWidth: 1))

            Spacer()
        }
        .padding()
    }

    func startGame() {
        score = 0
        timerCount = 10
        isGameActive = true
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if timerCount > 0 {
                timerCount -= 1
            } else {
                timer.invalidate()
                isGameActive = false
            }
        }
    }
}

// MARK: - 8. AYARLAR VE WALLPAPER AYDINLATMA MODÜLÜ
struct SettingsView: View {
    @Binding var wallpaperBrightness: Double
    @Binding var currentWallpaper: String
    @Binding var showModeSelector: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Ayarlar")
                .font(.largeTitle).bold()
                .foregroundColor(.pink)

            VStack(alignment: .leading, spacing: 15) {
                Text("Wallpaper Aydınlatması")
                    .font(.headline)
                    .foregroundColor(.white)

                HStack {
                    Image(systemName: "sun.min.fill").foregroundColor(.yellow)
                    Slider(value: $wallpaperBrightness, in: 0.1...1.0)
                        .accentColor(.pink)
                    Image(systemName: "sun.max.fill").foregroundColor(.yellow)
                }

                Divider().background(Color.white.opacity(0.2))

                Button(action: {
                    let wallpapers = ["bg1", "bg2", "bg3", "bg4", "wallpaper_default"]
                    currentWallpaper = wallpapers.randomElement() ?? "wallpaper_default"
                }) {
                    Label("Duvar Kağıdını Rastgele Değiştir", systemImage: "photo.on.rectangle.angled")
                        .foregroundColor(.white)
                }

                Divider().background(Color.white.opacity(0.2))

                Button(action: {
                    showModeSelector = true
                }) {
                    Label("Mod Seçim Ekranına Dön", systemImage: "arrow.uturn.left.circle.fill")
                        .foregroundColor(.pink)
                }
            }
            .padding(20)
            .background(.ultraThinMaterial)
            .cornerRadius(26)
            .overlay(RoundedRectangle(cornerRadius: 26).stroke(Color.white.opacity(0.2), lineWidth: 1))

            Spacer()
        }
        .padding()
    }
}
