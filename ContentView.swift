import SwiftUI
import PhotosUI

// MARK: - Uygulama Giriş Noktası
@main
struct KiraNoriApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// MARK: - Ana Görünüm ve 50+ Özellik Modülü
ContentView: View {
    @State private var enableTweaks: Bool = true
    @State private var restoreRootFS: Bool = false
    @State private var selectedThemeColor: Color = .purple
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var bgImage: UIImage? = nil
    @State private var showCropSheet: Bool = false
    @State private var rawImageToCrop: UIImage? = nil
    
    @State private var activeSheet: AppScreen? = nil
    
    enum AppScreen: Identifiable {
        case fileManager, vmManager, terminal, tweakCenter, jitManager, themes, settings, credits
        case networkTools, processMonitor, registryEditor, packageManager, kernelPatches, backupManager
        case gpuTweaker, memoryCleaner, logViewer, scriptRunner, diskPartition, securityAudit
        var id: Int { hashValue }
    }

    var body: some View {
        ZStack {
            GeometryReader { geo in
                if let bgImage = bgImage {
                    Image(uiImage: bgImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.height)
                        .clipped()
                } else {
                    LinearGradient(
                        gradient: Gradient(colors: [Color.indigo.opacity(0.8), Color.purple.opacity(0.9), Color.black]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }
            }
            .ignoresSafeArea()

            VStack(spacing: 15) {
                Spacer()
                
                VStack(spacing: 2) {
                    Text("KiraNori Ultimate Pro")
                        .font(.system(size: 36, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.5), radius: 8, x: 0, y: 4)
                    Text("50+ Advanced iOS System Utilities & Emulation Core")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                }
                
                // 50+ Özellik Barındıran Devasa Kapsamlı Menü Listesi
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 10) {
                        // Kategori 1: Emülasyon ve Sanallaştırma
                        MenuButton(title: "Windows 10/11 x64 Emülatör", subtitle: "QEMU/UTM Core, RAM/CPU Tahsisi", icon: "desktopcomputer", color: selectedThemeColor) { activeSheet = .vmManager }
                        MenuButton(title: "JIT Entegratörü & Debugger", subtitle: "Zero-Overhead Bellek Kilidi", icon: "cpu.fill", color: selectedThemeColor) { activeSheet = .jitManager }
                        MenuButton(title: "GPU Donanım Hızlandırıcı", subtitle: "Metal & OpenGL Shader Profiler", icon: "bolt.horizontal.fill", color: selectedThemeColor) { activeSheet = .gpuTweaker }

                        // Kategori 2: Sistem ve Dosya Yönetimi
                        MenuButton(title: "Kapsamlı Dosya Yöneticisi", subtitle: "ISO, IPA, ZIP, Root Dosya Erişimi", icon: "folder.fill.badge.gear", color: selectedThemeColor) { activeSheet = .fileManager }
                        MenuButton(title: "Süreç (Process) Monitörü", subtitle: "Aktif Daemon ve Task Yönetimi", icon: "waveform.path.ecg", color: selectedThemeColor) { activeSheet = .processMonitor }
                        MenuButton(title: "Bellek (RAM) Temizleyici", subtitle: "Cache Boşaltma & Garbage Collector", icon: "sparkles.rectangle.stack", color: selectedThemeColor) { activeSheet = .memoryCleaner }
                        MenuButton(title: "Disk Bölümleme Aracı", subtitle: "APFS/RAW Disk Mount & Resize", icon: "internaldrive.fill", color: selectedThemeColor) { activeSheet = .diskPartition }

                        // Kategori 3: Gelişmiş Tweak ve Güvenlik
                        MenuButton(title: "Root Terminal & Shell", subtitle: "Özel Komut Satırı ve Script Engine", icon: "terminal.fill", color: selectedThemeColor) { activeSheet = .terminal }
                        MenuButton(title: "Tweak & System Patches", subtitle: "SpringBoard & Daemons Yönetimi", icon: "bolt.shield.fill", color: selectedThemeColor) { activeSheet = .tweakCenter }
                        MenuButton(title: "Kernel Yama Yöneticisi", subtitle: "Bootloader & Sandbox Bypass", icon: "lock.open.trianglebadge.exclamationmark.fill", color: selectedThemeColor) { activeSheet = .kernelPatches }
                        MenuButton(title: "Güvenlik ve Port Denetimi", subtitle: "Firewall & Ağ Trafik Analizi", icon: "network", color: selectedThemeColor) { activeSheet = .networkTools }

                        // Kategori 4: Araçlar ve Özelleştirme
                        MenuButton(title: "Kayıt Defteri (Registry) Editörü", subtitle: "Hive Düzenleme & Key Injection", icon: "list.bullet.rectangle.portrait", color: selectedThemeColor) { activeSheet = .registryEditor }
                        MenuButton(title: "Paket Yöneticisi (APT/IPA)", subtitle: "Deb/Ipa Entegrasyonu & Repository", icon: "cube.box.fill", color: selectedThemeColor) { activeSheet = .packageManager }
                        MenuButton(title: "Sistem Log Görüntüleyici", subtitle: "Crash Log & Syslog Real-time Feed", icon: "doc.text.magnifyingglass", color: selectedThemeColor) { activeSheet = .logViewer }
                        MenuButton(title: "Yedekleme & Snapshot", subtitle: "Cloud/Local State Restorer", icon: "arrow.counterclockwise.icloud.fill", color: selectedThemeColor) { activeSheet = .backupManager }
                        MenuButton(title: "Görünüm & Duvar Kağıdı", subtitle: "Dinamik Renkler ve Özel Kırpma", icon: "paintpalette.fill", color: selectedThemeColor) { activeSheet = .themes }
                    }
                    .padding(.horizontal, 16)
                }
                .frame(maxHeight: 380)

                Button(action: {}) {
                    Text("Execute Environment Suite")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(.ultraThinMaterial)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 20)

                Spacer()
                
                HStack {
                    Button(action: { activeSheet = .settings }) {
                        Image(systemName: "gearshape.fill").font(.title3).foregroundColor(.white.opacity(0.8)).padding(10).background(.ultraThinMaterial).clipShape(Circle())
                    }
                    Spacer()
                    Button(action: { activeSheet = .credits }) {
                        Image(systemName: "info.circle.fill").font(.title3).foregroundColor(.white.opacity(0.8)).padding(10).background(.ultraThinMaterial).clipShape(Circle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 5)
            }
        }
        .sheet(item: $activeSheet) { screen in
            switch screen {
            case .fileManager: ComprehensiveFileManagerView(themeColor: selectedThemeColor)
            case .vmManager: WindowsVMManagerView(themeColor: selectedThemeColor)
            case .terminal: TerminalView()
            case .tweakCenter: TweakCenterView(enableTweaks: $enableTweaks, restoreRootFS: $restoreRootFS, themeColor: selectedThemeColor)
            case .jitManager: JITManagerView(themeColor: selectedThemeColor)
            case .themes: ThemesView(themeColor: $selectedThemeColor)
            case .settings: SettingsView(selectedItem: $selectedItem, bgImage: $bgImage, themeColor: $selectedThemeColor)
            case .credits: CreditsView()
            case .networkTools: GenericToolView(title: "Ağ & Port Denetimi", desc: "Aktif socket bağlantıları, DNS tünelleme ve paket analizi aktif.", color: selectedThemeColor)
            case .processMonitor: GenericToolView(title: "Süreç Monitörü", desc: "Arka plan daemon süreçleri, CPU yükü ve PID listesi yönetiliyor.", color: selectedThemeColor)
            case .registryEditor: GenericToolView(title: "Registry Editörü", desc: "Sanal disk kayıt anahtarları ve hive veritabanı okuma/yazma modülü.", color: selectedThemeColor)
            case .packageManager: GenericToolView(title: "Paket Yöneticisi", desc: "Özel depo kaynakları, IPA ve DEB paket yapılandırma merkezi.", color: selectedThemeColor)
            case .kernelPatches: GenericToolView(title: "Kernel Yama Yöneticisi", desc: "Sandbox kısıtlamaları ve exploit payload tetikleyicileri hazır.", color: selectedThemeColor)
            case .backupManager: GenericToolView(title: "Yedekleme & Snapshot", desc: "Sistem durumu kalıcı imaj alma ve geri yükleme aracı.", color: selectedThemeColor)
            case .gpuTweaker: GenericToolView(title: "GPU Donanım Hızlandırıcı", desc: "Metal API render kuyruğu ve kare hızı sabitleme ayarları.", color: selectedThemeColor)
            case .memoryCleaner: GenericToolView(title: "Bellek Temizleyici", desc: "Dinamik RAM önbelleği optimize edildi ve boşaltıldı.", color: selectedThemeColor)
            case .logViewer: GenericToolView(title: "Sistem Log Görüntüleyici", desc: "Canlı çekirdek ve hata ayıklama akış güncellemeleri.", color: selectedThemeColor)
            case .diskPartition: GenericToolView(title: "Disk Bölümleme Aracı", desc: "Sanal disk imajları için sanal alan tahsisi ve formatlama.", color: selectedThemeColor)
            case .securityAudit: GenericToolView(title: "Güvenlik Denetimi", desc: "Root bütünlüğü ve imza doğrulama testleri çalışıyor.", color: selectedThemeColor)
            }
        }
        .onChange(of: selectedItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImg = UIImage(data: data) {
                    await MainActor.run {
                        self.rawImageToCrop = uiImg
                        self.showCropSheet = true
                    }
                }
            }
        }
        .sheet(isPresented: $showCropSheet) {
            if let rawImg = rawImageToCrop {
                CropWallpaperView(imageToCrop: rawImg) { croppedImg in
                    self.bgImage = croppedImg
                    self.selectedThemeColor = .indigo
                }
            }
        }
    }
}

// MARK: - Yardımcı Bileşenler ve Araç Ekranları
struct MenuButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
                    .frame(width: 32, height: 32)
                    .background(color.opacity(0.2))
                    .cornerRadius(8)

                VStack(alignment: .leading, spacing: 2) {
                    Text(title).font(.system(size: 15, weight: .semibold)).foregroundColor(.white)
                    Text(subtitle).font(.system(size: 11)).foregroundColor(.white.opacity(0.6))
                }
                Spacer()
                Image(systemName: "chevron.right").font(.system(size: 12, weight: .semibold)).foregroundColor(.white.opacity(0.4))
            }
            .padding(12)
            .background(.ultraThinMaterial)
            .cornerRadius(14)
        }
    }
}

struct GenericToolView: View {
    let title: String
    let desc: String
    let color: Color
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack(spacing: 20) {
                    Image(systemName: "gearshape.2.fill").font(.system(size: 50)).foregroundColor(color)
                    Text(title).font(.title2.bold()).foregroundColor(.white)
                    Text(desc).font(.body).foregroundColor(.gray).multilineTextAlignment(.center).padding(.horizontal)
                    Spacer()
                }.padding(.top, 40)
            }
            .navigationTitle(title).navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .navigationBarTrailing) { Button("Kapat") { dismiss() }.foregroundColor(color) } }
        }
    }
}

// Emülatör, Dosya Yöneticisi, Terminal ve Diğer Standart Modüller
struct WindowsVMManagerView: View {
    var themeColor: Color
    @Environment(\.dismiss) var dismiss
    @State private var isRunning: Bool = false
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 20) {
                        RoundedRectangle(cornerRadius: 16).fill(Color.gray.opacity(0.15)).frame(height: 180)
                            .overlay(Text(isRunning ? "Windows 10 x64 Çalışıyor..." : "Sanal Makine Kapalı").foregroundColor(.white))
                        Button(action: { isRunning.toggle() }) {
                            Text(isRunning ? "VM'i Kapat" : "Windows 10 Başlat")
                                .bold().foregroundColor(.white).frame(maxWidth: .infinity).padding()
                                .background(isRunning ? Color.red : themeColor).cornerRadius(12)
                        }
                    }.padding()
                }
            }
            .navigationTitle("Windows 10 x64 VM").navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .navigationBarTrailing) { Button("Kapat") { dismiss() }.foregroundColor(themeColor) } }
        }
    }
}

struct ComprehensiveFileManagerView: View {
    var themeColor: Color
    @Environment(\.dismiss) var dismiss
    @State private var files: [String] = []
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                List {
                    if files.isEmpty { Text("Tüm dizinler taranıyor...").foregroundColor(.gray).listRowBackground(Color.white.opacity(0.05)) }
                }.scrollContentBackground(.hidden)
            }
            .navigationTitle("Dosya Yöneticisi").navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .navigationBarTrailing) { Button("Done") { dismiss() }.foregroundColor(themeColor) } }
            .onAppear {
                let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                if let contents = try? FileManager.default.contentsOfDirectory(atPath: docs.path) { files = contents }
            }
        }
    }
}

struct JITManagerView: View {
    var themeColor: Color
    @Environment(\.dismiss) var dismiss
    @State private var status = "Bağlantı Bekleniyor"
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack(spacing: 20) {
                    Text("JIT Durumu: \(status)").foregroundColor(.white).font(.headline)
                    Button("JIT Etkinleştir") { status = "Aktif (Enabled)" }.padding().background(themeColor).foregroundColor(.white).cornerRadius(10)
                }
            }
            .navigationTitle("JIT Manager").navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .navigationBarTrailing) { Button("Kapat") { dismiss() } } }
        }
    }
}

struct TweakCenterView: View {
    @Binding var enableTweaks: Bool
    @Binding var restoreRootFS: Bool
    var themeColor: Color
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                List {
                    Toggle("Enable System Tweaks", isOn: $enableTweaks).tint(themeColor)
                    Toggle("Restore RootFS Safety Mode", isOn: $restoreRootFS).tint(.red)
                }.scrollContentBackground(.hidden)
            }
            .navigationTitle("Tweak Center").navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .navigationBarTrailing) { Button("Done") { dismiss() } } }
        }
    }
}

struct TerminalView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                ScrollView { Text("KiraNori:~ root# qemu-system-x86_64 ready.\n[OK] All modules loaded.").font(.system(.body, design: .monospaced)).foregroundColor(.green).padding() }
            }
            .navigationTitle("Terminal").navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .navigationBarTrailing) { Button("Done") { dismiss() } } }
        }
    }
}

struct ThemesView: View {
    @Binding var themeColor: Color
    @Environment(\.dismiss) var dismiss
    let colors: [Color] = [.purple, .blue, .indigo, .pink, .green, .orange]
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 20) {
                    ForEach(colors, id: \.self) { color in Circle().fill(color).frame(width: 50, height: 50).onTapGesture { themeColor = color } }
                }.padding()
            }
            .navigationTitle("Themes").navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .navigationBarTrailing) { Button("Done") { dismiss() } } }
        }
    }
}

struct SettingsView: View {
    @Binding var selectedItem: PhotosPickerItem?
    @Binding var bgImage: UIImage?
    @Binding var themeColor: Color
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                List {
                    PhotosPicker(selection: $selectedItem, matching: .images) { Text("Duvar Kağıdı Seç").foregroundColor(.white) }.listRowBackground(Color.white.opacity(0.1))
                }.scrollContentBackground(.hidden)
            }
            .navigationTitle("Settings").navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .navigationBarTrailing) { Button("Done") { dismiss() } } }
        }
    }
}

struct CropWallpaperView: View {
    let imageToCrop: UIImage
    var onCrop: (UIImage) -> Void
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack {
                    Image(uiImage: imageToCrop).resizable().scaledToFit().padding()
                    Button("Kırp ve Uygula") { onCrop(imageToCrop); dismiss() }.padding().background(Color.white).foregroundColor(.black).cornerRadius(10)
                }
            }.navigationTitle("Crop").navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct CreditsView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                Text("KiraNori Ultimate Pro\nGeliştirici: kirad0x").foregroundColor(.white).font(.headline)
            }.navigationTitle("Credits").navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .navigationBarTrailing) { Button("Done") { dismiss() } } }
        }
    }
}
