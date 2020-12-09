import vue from 'rollup-plugin-vue'
import resolve from 'rollup-plugin-node-resolve'
import json from '@rollup/plugin-json'
import commonjs from '@rollup/plugin-commonjs'
import babel from 'rollup-plugin-babel'
import builtins from '@erquhart/rollup-plugin-node-builtins'
import globals from 'rollup-plugin-node-globals'
import copy from 'rollup-plugin-copy'
import postcss from 'rollup-plugin-postcss'
import modify from 'rollup-plugin-modify'
import { terser } from 'rollup-plugin-terser'
import filesize from 'rollup-plugin-filesize'
import serve from 'rollup-plugin-serve'

const production = !process.env.ROLLUP_WATCH

export default {
  input: {
    'phoenix-core': 'workspaces/core/src/phoenix.js',
    'phoenix-app-draw-io': 'workspaces/app-draw-io/src/app.js',
    'phoenix-app-files': 'workspaces/app-files/src/app.js',
    'phoenix-app-markdown-editor': 'workspaces/app-markdown-editor/src/app.js',
    'phoenix-app-media-viewer': 'workspaces/app-media-viewer/src/app.js',
  },
  output: {
    dir: 'dist',
    format: 'amd',
    sourcemap: !production,
    amd: {
      autoId: true
    }
  },
  onwarn: warning => {
    if (warning.code !== 'CIRCULAR_DEPENDENCY') {
      console.error(`(!) ${ warning.message }`)
    }
  },
  plugins: [
    vue({ css: true }),
    postcss(),
    resolve(
      {
        mainFields: ['browser', 'jsnext', 'module', 'main'],
        include: 'node_modules/**',
        preferBuiltins: true
      }
    ),
    babel({
      exclude: 'node_modules/**',
      runtimeHelpers: true
    }),
    modify({
      'process.env.NODE_ENV': JSON.stringify('production'),
      /* fix for 'assignment to undeclared variable dav' in davclient.js/lib/client.js 6:0 */
      /* remove after pending PR is merged */
      "if (typeof dav === 'undefined') { dav = {}; }": 'var dav = dav || {}',
    }),
    commonjs({
      include: 'node_modules/**'
    }),
    builtins(),
    globals(),
    json(),
    copy({
      targets: [
        { src: 'www/index.html', dest: 'dist' },
        { src: 'www/oidc-callback.html', dest: 'dist' },
        { src: 'www/oidc-silent-redirect.html', dest: 'dist' },
        { src: 'www/boot.js', dest: 'dist' },
        { src: 'workspaces/core/manifest.json', dest: 'dist' },
        { src: 'workspaces/core/themes', dest: 'dist' },
        { src: 'workspaces/core/config.json.sample-oc10', dest: 'dist', rename: 'config.json' },
        { src: 'node_modules/requirejs/require.js', dest: 'dist' },
      ]
    }),
    !production && serve({
      contentBase: ['dist'],
    }),
    production && terser(),
    production && filesize(),
  ],
}
