import vue from 'rollup-plugin-vue'
import resolve from 'rollup-plugin-node-resolve'
import json from '@rollup/plugin-json'
import commonjs from '@rollup/plugin-commonjs'
import babel from 'rollup-plugin-babel'
import builtins from '@erquhart/rollup-plugin-node-builtins'
import globals from 'rollup-plugin-node-globals'
import replace from '@rollup/plugin-replace'
import copy from 'rollup-plugin-copy'
import postcss from 'rollup-plugin-postcss'
const production = !process.env.ROLLUP_WATCH
/*import serve from 'rollup-plugin-serve'*/

const gen = c => {
  return {
    input: c.input,
    output: {
      dir: c.output,
      name: 'main',
      entryFileNames: 'index.js',
      format: 'iife',
      sourcemap: !production,
      strict : false
    },
    inlineDynamicImports: true,
    onwarn: warning => {
      if (warning.code !== 'CIRCULAR_DEPENDENCY') {
        console.error(`(!) ${ warning.message }`)
      }
    },
    plugins: [
      vue({ css: true }),
      postcss(),
      replace({
        'process.env.NODE_ENV': JSON.stringify('production')
      }),
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
      commonjs({
        include: 'node_modules/**'
      }),
      builtins(),
      globals(),
      json(),
      ...(c.plugins || []),
    ]
  }
}

export default [
  {
    input: 'workspaces/phoenix/src/phoenix.js',
    output: 'dist/phoenix',
    plugins: [
      copy({
        targets: [
          { src: 'static/index.html', dest: 'dist' },
          { src: 'static/themes', dest: 'dist' },
          { src: 'static/config.json.sample-oc10', dest: 'dist', rename: 'config.json' },
          { src: 'static/manifest.json', dest: 'dist' },
          { src: 'static/oidc-callback.html', dest: 'dist' },
          { src: 'static/oidc-silent-redirect.html', dest: 'dist' },
          { src: 'node_modules/requirejs/require.js', dest: 'dist' },
        ]
      }),
      /*serve({
        contentBase: ['dist'],
        host: '0.0.0.0',
        port: 9100,
      }),*/
    ],
  },
  {
    input: 'workspaces/draw-io/src/app.js',
    output: 'dist/draw-io',
  },
  {
    input: 'workspaces/files/src/default.js',
    output: 'dist/files',
  },
  {
    input: 'workspaces/markdown-editor/src/app.js',
    output: 'dist/markdown-editor',
  },
  {
    input: 'workspaces/media-viewer/src/app.js',
    output: 'dist/media-viewer',
  },
].map(gen)
