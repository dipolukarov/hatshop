<?php /* Smarty version 2.6.27, created on 2013-08-29 12:54:19
         compiled from header.tpl */ ?>
<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('modifier', 'prepare_link', 'header.tpl', 2, false),)), $this); ?>
<div id="header">
	<a href="<?php echo ((is_array($_tmp="index.php")) ? $this->_run_mod_handler('prepare_link', true, $_tmp, 'http') : smarty_modifier_prepare_link($_tmp, 'http')); ?>
">
		<img src="images/title.png" alt="Site title" />
	</a>
</div>