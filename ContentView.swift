import SwiftUI
import PhotosUI

struct ContentView: View {
    // MARK: - State Variables
    @State private var enableTweaks: Bool = true
    @State private var restoreRootFS: Bool = false
    @State private var selectedThemeColor: Color = .purple
    
    // Wallpaper States
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var bgImage: UIImage? = nil
    @State private var showCropSheet: Bool = false
    @State private var rawImageToCrop: UIImage? = nil
    
    // Active Navigation Sheets
    @State private var activeSheet: AppScreen? = nil
    
    enum AppScreen: Identifiable {
        case fileManager
        case vmManager
        case terminal
        case tweakCenter
        case jitManager
        case themes
        case settings
        case credits
        
        var id: Int { hashValue }
    }

    var body: some View {
        ZStack {
            // MARK: - Dinamik Arka Plan
            GeometryReader { geo in
                if let bgImage = bgImage {
                    Image(uiImage: bgImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.height)
                        .clipped()
                } else {
                    LinearGradient(
                        gradient: Gradient(colors: [Color.indigo.opacity(0.7), Color.purple.opacity(0.8), Color.black]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }
            }
            .ignoresSafeArea()

            // MARK: - Ana Arayüz (Taurine / Modern Glassmorphism)
            VStack(spacing: 20) {
                Spacer()
                
                // Başlık
                VStack(spacing: 4) {
                    Text("KiraNori Pro")
                        .font(.system(size: 42, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 4)
                    Text("Advanced iOS Virtualization & Tweak Suite")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                }
                
                // Ana Özellik Menü Kartları (Buzlu Cam)
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 12) {
                        MenuButton(
                            title: "Windows 10 x64 Emülatör",
                            subtitle: "QEMU / UTM Core Engine",
                            icon: "desktopcomputer",
                            color: selectedThemeColor
                        ) {
                            activeSheet = .vmManager
                        }

                        MenuButton(
                            title: "Gelişmiş Dosya Yöneticisi",
                            subtitle: "Tüm Formatlar, IPA, ISO ve Payload",
                            icon: "folder.fill.badge.gear",
                            color: selectedThemeColor
                        ) {
                            activeSheet = .fileManager
                        }

                        MenuButton(
                            title: "JIT Entegratörü & Debugger",
                            subtitle: "Emülatörler İçin Performans Kilidi",
                            icon: "cpu.fill",
                            color: selectedThemeColor
                        ) {
                            activeSheet = .jitManager
                        }

                        MenuButton(
                            title: "Root Terminal & Shell",
                            subtitle: "Komut Satırı ve Özel Scriptler",
                            icon: "terminal.fill",
                            color: selectedThemeColor
                        ) {
                            activeSheet = .terminal
                        }

                        MenuButton(
                            title: "Tweak & System Patches",
                            subtitle: "Gelişmiş Sistem Ayarları",
                            icon: "bolt.shield.fill",
                            color: selectedThemeColor
                        ) {
                            activeSheet = .tweakCenter
                        }

                        MenuButton(
                            title: "Görünüm & Duvar Kağıdı",
                            subtitle: "Özel Kırpma ve Dinamik Renkler",
                            icon: "paintpalette.fill",
                            color: selectedThemeColor
                        ) {
                            activeSheet = .themes
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .frame(maxHeight: 340)

                Button(action: {
                    // Sistem tetikleyici
                }) {
                    Text("Execute Environment")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(.ultraThinMaterial)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 24)

                Spacer()
                
                HStack {
                    Button(action: { activeSheet = .settings }) {
                        Image(systemName: "gearshape.fill")
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.8))
                            .padding(12)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                    Spacer()
                    Button(action: { activeSheet = .credits }) {
                        Image(systemName: "info.circle.fill")
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.8))
                            .padding(12)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 10)
            }
        }
        .sheet(item: $activeSheet) { screen in
            switch screen {
            case .fileManager:
                ComprehensiveFileManagerView(themeColor: selectedThemeColor)
            case .vmManager:
                WindowsVMManagerView(themeColor: selectedThemeColor)
            case .terminal:
                TerminalView()
            case .tweakCenter:
                TweakCenterView(enableTweaks: $enableTweaks, restoreRootFS: $restoreRootFS, themeColor: selectedThemeColor)
            case .jitManager:
                JITManagerView(themeColor: selectedThemeColor)
            case .themes:
                ThemesView(themeColor: $selectedThemeColor)
            case .settings:
                SettingsView(selectedItem: $selectedItem, bgImage: $bgImage, themeColor: $selectedThemeColor)
            case .credits:
                CreditsView()
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

struct MenuButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(color)
                    .frame(width: 36, height: 36)
                    .background(color.opacity(0.2))
                    .cornerRadius(10)

                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.6))
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.4))
            }
            .padding(14)
            .background(.ultraThinMaterial)
            .cornerRadius(16)
        }
    }
}

struct WindowsVMManagerView: View {
    var themeColor: Color
    @Environment(\.dismiss) var dismiss
    
    @State private var isRunning: Bool = false
    @State private var ramAllocation: Double = 4.0
    @State private var cpuCores: Int = 4
    @State private var selectedISO: String = "Windows_10_x64.iso"
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.gray.opacity(0.15))
                                .frame(height: 200)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(themeColor.opacity(0.5), lineWidth: 1)
                                )
                            
                            if isRunning {
                                VStack(spacing: 8) {
                                    ProgressView()
                                        .tint(.white)
                                    Text("Windows 10 x64 Booting...")
                                        .font(.system(.subheadline, design: .monospaced))
                                        .foregroundColor(.green)
                                    Text("Architecture: x86_64 | RAM: \(Int(ramAllocation))GB | Cores: \(cpuCores)")
                                        .font(.system(size: 11, design: .monospaced))
                                        .foregroundColor(.gray)
                                }
                            } else {
                                VStack(spacing: 8) {
                                    Image(systemName: "desktopcomputer")
                                        .font(.system(size: 48))
                                        .foregroundColor(themeColor)
                                    Text("Sanal Makine Kapalı")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Text("ISO Dosyası: \(selectedISO)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        
                        HStack(spacing: 15) {
                            Button(action: { isRunning.toggle() }) {
                                HStack {
                                    Image(systemName: isRunning ? "stop.fill" : "play.fill")
                                    Text(isRunning ? "VM'i Kapat (Power Off)" : "Windows 10 Başlat")
                                }
                                .font(.bold(.body)())
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(isRunning ? Color.red : themeColor)
                                .cornerRadius(12)
                            }
                        }

                        VStack(alignment: .leading, spacing: 15) {
                            Text("QEMU Donanım Ayarları (x64)")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            VStack(alignment: .leading) {
                                Text("RAM Tahsisi: \(Int(ramAllocation)) GB")
                                    .foregroundColor(.gray)
                                Slider(value: $ramAllocation, in: 1...8, step: 1)
                                    .accentColor(themeColor)
                            }
                            
                            HStack {
                                Text("CPU Çekirdek Sayısı")
                                    .foregroundColor(.gray)
                                Spacer()
                                Picker("Cores", selection: $cpuCores) {
                                    Text("2 Çekirdek").tag(2)
                                    Text("4 Çekirdek").tag(4)
                                    Text("6 Çekirdek").tag(6)
                                }
                                .pickerStyle(MenuPickerStyle())
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.06))
                        .cornerRadius(16)
                    }
                    .padding()
                }
            }
            .navigationTitle("Windows 10 x64 VM")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kapat") { dismiss() }.foregroundColor(themeColor)
                }
            }
        }
    }
}

struct ComprehensiveFileManagerView: View {
    var themeColor: Color
    @Environment(\.dismiss) var dismiss
    
    @State private var fileList: [FileURLItem] = []
    
    struct FileURLItem: Identifiable {
        let id = UUID()
        let url: URL
        let name: String
        let size: String
        let extensionType: String
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                List {
                    if fileList.isEmpty {
                        Text("Documents dizininde dosya bulunamadı.")
                            .foregroundColor(.gray)
                            .listRowBackground(Color.white.opacity(0.05))
                    } else {
                        ForEach(fileList) { item in
                            HStack(spacing: 12) {
                                Image(systemName: iconForExtension(item.extensionType))
                                    .foregroundColor(themeColor)
                                    .font(.title3)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.name)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Text("Boyut: \(item.size) | Tür: .\(item.extensionType.uppercased())")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                            }
                            .padding(.vertical, 4)
                            .listRowBackground(Color.white.opacity(0.08))
                        }
                        .onDelete(perform: deleteFiles)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Tüm Dosya Yöneticisi")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }.foregroundColor(themeColor)
                }
            }
            .onAppear(perform: loadAllFiles)
        }
    }
    
    func iconForExtension(_ ext: String) -> String {
        switch ext.lowercased() {
        case "iso", "img": return "opticaldisc.fill"
        case "ipa": return "app.badge.fill"
        case "zip", "rar", "7z": return "doc.zipper"
        case "txt", "log", "json": return "doc.text.fill"
        default: return "doc.fill"
        }
    }
    
    func loadAllFiles() {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        if let contents = try? FileManager.default.contentsOfDirectory(at: docs, includingPropertiesForKeys: [.fileSizeKey]) {
            fileList = contents.map { url in
                let resources = try? url.resourceValues(forKeys: [.fileSizeKey])
                let sizeBytes = resources?.fileSize ?? 0
                let sizeString = ByteCountFormatter.string(fromByteCount: Int64(sizeBytes), countStyle: .file)
                return FileURLItem(url: url, name: url.lastPathComponent, size: sizeString, extensionType: url.pathExtension)
            }
        }
    }
    
    func deleteFiles(at offsets: IndexSet) {
        for index in offsets {
            let item = fileList[index]
            try? FileManager.default.removeItem(at: item.url)
        }
        loadAllFiles()
    }
}

struct JITManagerView: View {
    var themeColor: Color
    @Environment(\.dismiss) var dismiss
    @State private var jitStatus: String = "Aktif Edilmedi (Not Attached)"
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack(spacing: 20) {
                    Image(systemName: "cpu")
                        .font(.system(size: 60))
                        .foregroundColor(themeColor)
                    
                    Text("JIT Durumu: \(jitStatus)")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Button(action: {
                        jitStatus = "Bağlantı Kuruldu (JIT Enabled)"
                    }) {
                        Text("JIT'i Tetikle / Etkinleştir")
                            .font(.bold(.body)())
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(themeColor)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding(.top, 40)
            }
            .navigationTitle("JIT Manager")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kapat") { dismiss() }.foregroundColor(themeColor)
                }
            }
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
                    Toggle("Enable System Tweaks", isOn: $enableTweaks)
                        .tint(themeColor)
                    Toggle("Restore RootFS Safety Mode", isOn: $restoreRootFS)
                        .tint(.red)
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Tweak Center")
            .navigationBarTitleDisplayMode(.inline)
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
                ScrollView {
                    Text("KiraNori:~ root# qemu-system-x86_64 -m 4G -cpu host\n[OK] Virtualization backend initialized.\n[OK] Windows x64 Disk image mounted successfully.")
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.green)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                }
            }
            .navigationTitle("Root Terminal")
            .navigationBarTitleDisplayMode(.inline)
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
                    ForEach(colors, id: \.self) { color in
                        Circle().fill(color).frame(width: 50, height: 50)
                            .onTapGesture { themeColor = color }
                    }
                }.padding()
            }
            .navigationTitle("Themes")
            .navigationBarTitleDisplayMode(.inline)
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
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        Text("Özel Duvar Kağıdı Seç ve Kırp").foregroundColor(.white)
                    }.listRowBackground(Color.white.opacity(0.1))
                }.scrollContentBackground(.hidden)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
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
                    Button("Kırp ve Uygula") {
                        onCrop(imageToCrop)
                        dismiss()
                    }.padding().background(Color.white).foregroundColor(.black).cornerRadius(10)
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
                Text("KiraNori Pro Suite\nGeliştirici: kirad0x").foregroundColor(.white).font(.headline)
            }.navigationTitle("Credits").navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .navigationBarTrailing) { Button("Done") { dismiss() } } }
        }
    }
}
