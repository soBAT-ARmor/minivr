// minivr - M0: 让一张图从自己的代码里出来
// 输出 24 位 BMP，Windows 照片可直接打开，不需要任何第三方库。

#include <cstdio>
#include <cstdint>
#include <vector>

static void writeBMP(const char* path, int W, int H,
                     const std::vector<unsigned char>& rgb) {
    const int rowSize = (W * 3 + 3) & ~3;   // 每行补齐到 4 字节
    const uint32_t dataSize = (uint32_t)rowSize * H;
    const uint32_t fileSize = 54 + dataSize;

    unsigned char hdr[54] = {};
    hdr[0] = 'B'; hdr[1] = 'M';
    auto put32 = [&](int o, uint32_t v) {
        hdr[o] = v & 0xFF; hdr[o + 1] = (v >> 8) & 0xFF;
        hdr[o + 2] = (v >> 16) & 0xFF; hdr[o + 3] = (v >> 24) & 0xFF;
    };
    auto put16 = [&](int o, uint16_t v) {
        hdr[o] = v & 0xFF; hdr[o + 1] = (v >> 8) & 0xFF;
    };
    put32(2, fileSize);
    put32(10, 54);            // 像素数据偏移
    put32(14, 40);            // DIB 头大小
    put32(18, (uint32_t)W);
    put32(22, (uint32_t)H);
    put16(26, 1);             // planes
    put16(28, 24);            // 24 位
    put32(34, dataSize);

    FILE* f = fopen(path, "wb");
    if (!f) { printf("open failed: %s\n", path); return; }
    fwrite(hdr, 1, 54, f);

    std::vector<unsigned char> row(rowSize, 0);
    for (int y = H - 1; y >= 0; --y) {          // BMP 自下而上
        for (int x = 0; x < W; ++x) {
            int i = (y * W + x) * 3;
            row[x * 3 + 0] = rgb[i + 2];        // B
            row[x * 3 + 1] = rgb[i + 1];        // G
            row[x * 3 + 2] = rgb[i + 0];        // R
        }
        fwrite(row.data(), 1, rowSize, f);
    }
    fclose(f);
}

int main() {
    const int W = 800, H = 600;
    std::vector<unsigned char> img((size_t)W * H * 3);

    for (int y = 0; y < H; ++y) {
        for (int x = 0; x < W; ++x) {
            size_t i = ((size_t)y * W + x) * 3;
            img[i + 0] = (unsigned char)(x * 255 / W);   // R
            img[i + 1] = (unsigned char)(y * 255 / H);   // G
            img[i + 2] = 128;                            // B
        }
    }

    writeBMP("out.bmp", W, H, img);
    printf("wrote out.bmp (%dx%d)\n", W, H);
    return 0;
}
