package com.foobnix.sys;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Iterator;

import com.foobnix.android.utils.LOG;
import com.foobnix.ext.CacheZipUtils.CacheDir;
import com.foobnix.mobi.parser.IOUtils;

import net.lingala.zip4j.core.ZipFile;
import net.lingala.zip4j.exception.ZipException;
import net.lingala.zip4j.io.ZipInputStream;
import net.lingala.zip4j.model.FileHeader;

public class ZipArchiveInputStream extends InputStream {

    private Iterator<FileHeader> iterator;
    private FileHeader current;
    private ZipFile zp;
    private ZipInputStream inputStream;
    private File tempFile;
    private String encoding = "UTF-8";

    // public static final Lock lock = new ReentrantLock();

    public ZipArchiveInputStream(String file) {
        // CacheZipUtils.cacheLock.lock();
        try {
            zp = new ZipFile(file);
            iterator = zp.getFileHeaders().iterator();
        } catch (ZipException e) {
            LOG.e(e);
        }
    }

    public ZipArchiveInputStream(InputStream is, String encoding) {
        // CacheZipUtils.cacheLock.lock();
        this.encoding = encoding;
        try {
            if (tempFile != null) {
                tempFile.delete();
            }
            tempFile = new File(CacheDir.ZipApp.getDir(), "temp.zip");

            LOG.d("zip-tempFile", tempFile.getPath());
            IOUtils.copy(is, new FileOutputStream(tempFile));
            is.close();

            zp = new ZipFile(tempFile);
            zp.setFileNameCharset(encoding);
            iterator = zp.getFileHeaders().iterator();
        } catch (Exception e) {
            LOG.e(e);
        }
    }

    @Override
    public void close() throws IOException {
        // CacheZipUtils.cacheLock.unlock();

        if (tempFile != null) {
            tempFile.delete();
        }
        closeStream();
        if (zp != null) {
            zp = null;
        }
    }

    private void closeStream() {
        if (inputStream != null) {
            try {
                inputStream.close(true);
                inputStream = null;
            } catch (Exception e) {
                LOG.e(e);
            }
        }
    }

    public ArchiveEntry getNextEntry() {
        if (iterator == null || !iterator.hasNext()) {
            return null;
        }
        closeStream();
        current = iterator.next();
        return current != null ? new ArchiveEntry(current, encoding) : null;
    }

    private void openStream() throws IOException {
        if (inputStream == null) {
            try {
                inputStream = zp.getInputStream(current);
            } catch (ZipException e) {
                throw new IOException();
            }
        }
    }

    @Override
    public int read() throws IOException {
        openStream();
        return inputStream.read();
    }

    @Override
    public int read(byte[] b) throws IOException {
        openStream();
        return inputStream.read(b);
    }

    @Override
    public int read(byte[] b, int off, int len) throws IOException {
        openStream();
        return inputStream.read(b, off, len);
    }

}
